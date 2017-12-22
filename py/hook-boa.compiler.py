from PyInstaller.utils.hooks import collect_data_files, collect_submodules

datas = [
    (glob, files)
    for (glob, files)
    in collect_data_files('boa', include_py_files=True)
    if glob.endswith('.py')
]
