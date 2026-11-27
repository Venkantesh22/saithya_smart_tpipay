from pathlib import Path
from datetime import datetime
import shutil
import sys

SOURCE = Path("../saithya_smart_tpipay_backup")
TARGET = Path(".")

SKIP_DIRS = {
    ".git", ".dart_tool", "build", "Pods", "node_modules",
    ".gradle", ".idea", ".symlinks", "DerivedData"
}

def resolve_head(path):
    raw = path.read_bytes()

    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError:
        return None, 0

    lines = text.splitlines(keepends=True)
    output = []
    state = "normal"
    conflicts = 0

    for number, line in enumerate(lines, 1):
        marker = line.lstrip()

        if marker.startswith("<<<<<<<"):
            if state != "normal":
                raise ValueError(f"{path}:{number}: nested conflict")
            state = "ours"
            conflicts += 1

        elif marker.strip() == "=======":
            if state != "ours":
                raise ValueError(f"{path}:{number}: unexpected separator")
            state = "theirs"

        elif marker.startswith(">>>>>>>"):
            if state != "theirs":
                raise ValueError(f"{path}:{number}: unexpected ending")
            state = "normal"

        elif state == "normal" or state == "ours":
            output.append(line)

    if state != "normal":
        raise ValueError(f"{path}: incomplete conflict block")

    if conflicts == 0:
        return None, 0

    return "".join(output), conflicts


def main():
    if not SOURCE.is_dir():
        print("ERROR: Original backup folder not found:", SOURCE.resolve())
        return 1

    if not (TARGET / "pubspec.yaml").is_file():
        print("ERROR: Run this from the Flutter project root.")
        return 1

    source_files = []

    for path in SOURCE.rglob("*"):
        if not path.is_file() or path.is_symlink():
            continue

        relative = path.relative_to(SOURCE)

        if any(part in SKIP_DIRS for part in relative.parts):
            continue

        source_files.append(path)

    restored = {}
    total_conflicts = 0

    # Validate every source file before modifying anything.
    try:
        for src in source_files:
            content, count = resolve_head(src)
            if count:
                restored[src.relative_to(SOURCE)] = content
                total_conflicts += count
    except Exception as exc:
        print("RECOVERY STOPPED. No project files changed.")
        print(exc)
        return 1

    if not restored:
        print("No conflict blocks found in the source backup.")
        return 1

    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    safety = Path(f"../saithya_smart_tpipay_full_backup_{stamp}")

    # Back up files that will be modified.
    for relative in restored:
        current = TARGET / relative
        if current.is_file():
            destination = safety / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(current, destination)

    # Restore the HEAD side from the original backup.
    for relative, content in restored.items():
        destination = TARGET / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(content, encoding="utf-8")

    print("\nFULL PROJECT RECOVERY COMPLETED")
    print("Files restored:", len(restored))
    print("Conflict blocks resolved:", total_conflicts)
    print("Safety backup:", safety.resolve())
    print("Original source backup was not modified.")

    for relative in restored:
        print("Restored:", relative)

    return 0


if __name__ == "__main__":
    sys.exit(main())
