from pathlib import Path

import pytest


@pytest.fixture()
def render_config_file() -> Path:
    return Path("src") / "cad" / "render.yaml"


@pytest.fixture()
def cad_root_dir() -> Path:
    return Path("src") / "cad" / "scanner"


@pytest.fixture()
def parts_dir() -> Path:
    return Path("build") / "parts"
