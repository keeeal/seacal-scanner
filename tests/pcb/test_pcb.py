from pathlib import Path

from tests.utils import get_stems


def test_layers_config(layers_config: list[str]):
    assert isinstance(layers_config, list)
    assert len(layers_config) > 0
    assert all(isinstance(layer, str) for layer in layers_config)
    assert len(set(layers_config)) == len(layers_config)


def test_one_gerber_per_layer(
    layers_config: list[str], gerbers_dir: Path, gerber_file_prefix: str
):
    gbr_stems = (
        get_stems(gerbers_dir, suffix=".gbr")
        + get_stems(gerbers_dir, suffix=".gtl")
        + get_stems(gerbers_dir, suffix=".gbl")
    )
    assert all(stem.startswith(gerber_file_prefix) for stem in gbr_stems)
    assert set(layer.replace(".", "_") for layer in layers_config) == set(
        stem.replace(gerber_file_prefix, "", 1) for stem in gbr_stems
    )


def test_one_gerber_job(gerbers_dir: Path):
    gbrjob_stems = get_stems(gerbers_dir, suffix=".gbrjob")
    assert len(gbrjob_stems) == 1
