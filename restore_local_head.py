from pathlib import Path
from datetime import datetime
import shutil
import sys

SOURCE = Path("../saithya_smart_tpipay_backup/lib")
TARGET = Path("lib")

def main():
    if not SOURCE.is_dir() or not TARGET.is_dir():
        print("ERROR: Project or source backup folder not found.")
        return 1

    source_files = [
        p for p in SOURCE.rglob("*.dart") if p.is_file()
    ]

    if not source_files:
        print("ERROR: No Dart files found in the backup.")
        return 1

    restored = {}
    conflict_total = 0

    for src in source_files:
        lines = src.read_bytes().decode("utf-8").splitlines(keepends=True)
        output = []
        state = "normal"
        conflicts = 0

        for number, line in enumerate(lines, 1):
            marker = line.lstrip()

            if marker.startswith("<<<<<<<"):
                if state != "normal":
                    print(f"ERROR: Nested conflict at {src}:{number}")
                    return 1
                state = "ours"
                conflicts += 1

            elif marker.strip() == "=======":
                if state != "ours":
                    print(f"ERROR: Unexpected separator at {src}:{number}")
                    return 1
                state = "theirs"

            elif marker.startswith(">>>>>>>"):
                if state != "theirs":
                    print(f"ERROR: Unexpected ending at {src}:{number}")
                    return 1
                state = "normal"

            elif state in ("normal", "ours"):
                output.append(line)

        if state != "normal":
            print(f"ERROR: Incomplete conflict in {src}")
            return 1

        restored[src.relative_to(SOURCE)] = "".join(output)
        conflict_total += conflicts

    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    safety = Path(
        f"../saithya_smart_tpipay_before_restore_{stamp}/lib"
    )

    shutil.copytree(TARGET, safety)

    for relative, content in restored.items():
        destination = TARGET / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(content, encoding="utf-8")

    print("\nRECOVERY COMPLETED")
    print("Dart files restored:", len(restored))
    print("Conflict blocks resolved:", conflict_total)
    print("Safety backup:", safety.parent.resolve())
    print("Original source backup was not modified.")
    print("Files existing only in current lib were left untouched.")

    return 0

if __name__ == "__main__":
    sys.exit(main())
