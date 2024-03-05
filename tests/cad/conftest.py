from pathlib import Path
from typing import Any

import pytest
from yaml import safe_load


@pytest.fixture()
def render_config_file() -> Path:
    return Path("src") / "cad" / "render.yaml"


@pytest.fixture()
def render_config(render_config_file: Path) -> dict[str, Any]:
    with open(render_config_file) as f:
        return safe_load(f)


@pytest.fixture()
def parts_config(render_config: dict[str, Any]) -> dict[str, dict[str, Any]]:
    return render_config["parts"]


@pytest.fixture()
def cad_root_dir() -> Path:
    return Path("src") / "cad" / "scanner"


@pytest.fixture()
def parts_dir() -> Path:
    return Path("build") / "parts"
