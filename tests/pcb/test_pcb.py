from pathlib import Path


def test_pcb_layer_files_exist(
    pcb_names: list[str],
    layers_config: list[str],
    gerbers_dir: Path,
) -> None:
    assert pcb_names, "No PCBs found"
    assert layers_config, "No layers configured"

    for pcb_name in pcb_names:
        for layer in layers_config:
            pattern = f"{pcb_name}-{layer.replace('.', '_')}.*"
            files = list((gerbers_dir / pcb_name).glob(pattern))
            assert len(files) == 1, f"Found {len(files)} files for {pcb_name}: {layer}"


def test_pcb_job_files_exist(
    pcb_names: list[str],
    layers_config: list[str],
    gerbers_dir: Path,
) -> None:
    assert pcb_names, "No PCBs found"
    assert layers_config, "No layers configured"

    for pcb_name in pcb_names:
        file = gerbers_dir / pcb_name / f"{pcb_name}-job.gbrjob"
        assert file.exists(), f"No jobfile found for {pcb_name}"


def test_pcb_drill_files_exist(
    pcb_names: list[str],
    layers_config: list[str],
    gerbers_dir: Path,
) -> None:
    assert pcb_names, "No PCBs found"
    assert layers_config, "No layers configured"

    for pcb_name in pcb_names:
        file = gerbers_dir / pcb_name / f"{pcb_name}.drl"
        assert file.exists(), f"No jobfile found for {pcb_name}"
