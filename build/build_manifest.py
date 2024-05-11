import itertools
import os
import struct


def hashfunc(path):
    res = 0
    for c in list(path.lower().encode()):
        res = (res * 0x1003f + c) & 0xffffffff

    return res


def generate_manifest(paths):
    res = b'MNFS'
    res += struct.pack('<I', 1)
    res += struct.pack('<I', len(paths))
    for path in paths:
        res += struct.pack('<I', hashfunc(path))

    return res


def modpaths(modroot):
    paths = []

    def process_dir(path, level):
        files = []
        dirs = []

        with os.scandir(path) as it:
            for entry in it:
                if entry.name == '.' or entry.name == '..':
                    continue

                if entry.is_file():
                    files.append(entry.name)
                else:
                    dirs.append(entry.name)

        files = list(sorted(files, key=lambda item: item.upper()))
        dirs = list(sorted(dirs, key=lambda item: item.upper()))

        for file in files:
            while len(paths) <= level:
                paths.append([])
            paths[level].append(os.path.relpath(
                os.path.join(path, file), modroot))

        for dir in dirs:
            process_dir(os.path.relpath(os.path.join(path, dir)), level + 1)

    process_dir(modroot, 0)
    paths = list(itertools.chain.from_iterable(paths))

    try:
        paths.remove('mod.manifest')
    except ValueError:
        pass

    return paths


def main():
    paths = modpaths('dist')
    manifest = generate_manifest(paths)

    with open(os.path.join('dist', 'mod.manifest'), 'wb') as f:
        f.write(manifest)


if __name__ == '__main__':
    main()
