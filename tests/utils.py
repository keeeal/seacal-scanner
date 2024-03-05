from pathlib import Path
from typing import Optional


def has_suffix(path: Path, suffix: str) -> bool:
    return path.suffix.lower() == suffix.lower()


def get_stems(root: Path, suffix: Optional[str] = None) -> list[str]:
    return [f.stem for f in root.iterdir() if (suffix is None or has_suffix(f, suffix))]
