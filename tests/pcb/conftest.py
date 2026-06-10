from pathlib import Path

import pytest


@pytest.fixture()
def layers_config_file() -> Path:
    return Path("src") / "pcb" / "layers.txt"


@pytest.fixture()
def layers_config(layers_config_file: Path) -> list[str]:
    with open(layers_config_file) as f:
        lines = f.readlines()

    return list(filter(None, map(str.strip, lines)))


@pytest.fixture()
def pcb_root_dir() -> Path:
    return Path("src") / "pcb"


@pytest.fixture()
def pcb_names(pcb_root_dir: Path) -> list[str]:
    return [path.name for path in pcb_root_dir.iterdir() if path.is_dir()]


@pytest.fixture()
def gerbers_dir() -> Path:
    return Path("gerbers")
