from pathlib import Path

import pytest


@pytest.fixture()
def render_config_file() -> Path:
    return Path("cad") / "render.yaml"


@pytest.fixture()
def cad_root_dir() -> Path:
    return Path("cad") / "scanner"


@pytest.fixture()
def parts_output_dir() -> Path:
    return Path("output") / "parts"
