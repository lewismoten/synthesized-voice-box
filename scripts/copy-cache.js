/*
The Second Life Viewer does not provide
a way to export sound files that you have
previously uploaded. This script looks in
the cache folder for specific files with
known asset UUID's and copies them to
the sub folder "Assets" and renames them
with their actual name and appropriate
file extension. You'll need to have the
sounds play in-world before they appear
in the cache.

NOTE: The original files were uploaded as
PCM WAV files. The viewer receives them
as Ogg Vorbis files.

The script will also open the _assets.md
file and update the list with any new
UUID's found in the Clip.Data.txt file
based on it's ordinal position within the
list.
*/

const fs = require('fs');
const path = require('path');
const namedAssets = new Map();
const assetTypes = new Map();

const cachePath = '/users/lewismoten/library/caches/secondlife';

const getOggName = name => `${name}.ogg`;
const getCacheFileName = uuid => `${uuid}.dsf`;

const main = () => {
  files = getFilePaths('.', /\.(md)$/);
  files.forEach(getAssets);

  console.log("Done");
}
const getFilePaths = (dir, pattern = /\./) => {
  const files = fs.readdirSync(dir, { recursive: true, withFileTypes: true })
    .filter(item => !item.isDirectory())
    .filter(item => !item.path.startsWith('.git'))
    .map(item => path.join(item.path, item.name))
    .filter(item => pattern.test(item))
    ;
  return files;
}
const parseNonLinkedUuids = text => {
  // Spaces are important, as they indicate the UUID is not linked
  const pattern = / [\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12} /g;
  return Array.from(text.matchAll(pattern)).map(m => m[0].trim());
}
const parseNamedAssets = (text, uuids) => {
  const localAssets = new Map();

  for (let uuid of uuids) {
    if (localAssets.has(uuid)) continue;

    if (namedAssets.has(uuid)) {
      localAssets.set(uuid, namedAssets.get(uuid));
      continue;
    }
    // Name, Type, UUID
    const pattern = new RegExp(`\\| ([^|]+) \\| ([^|]+) \\| ${uuid}`);
    const foo = text.match(pattern);
    if (foo !== null) {
      const [, name, type] = foo;
      namedAssets.set(uuid, name);
      localAssets.set(uuid, name);
      assetTypes.set(uuid, type)
    } else {
      console.warn(`Name not found for asset: ${uuid}`)
    }
  }
  return localAssets;
}
const fetchMissingAssets = (file, localAssets) => {
  const dirPath = path.dirname(file);
  const files = fs.readdirSync(dirPath);
  localAssets.forEach((name, uuid) => {
    // exists
    if (files.some(file => file.startsWith(`${name}.`))) return;

    // find in cache
    const cacheFile = path.join(cachePath, getCacheFileName(uuid));
    if (fs.existsSync(cacheFile)) {
      const type = assetTypes.get(uuid);
      switch (type) {
        case "Sound":
          fs.copyFileSync(
            cacheFile,
            path.join(dirPath, getOggName(name))
          );
          break;
        default:
          console.warn("Unknown asset type: ", type);
          fs.copyFileSync(
            cacheFile,
            path.join(dirPath, `${name}.${type}`)
          );
          break;
      }
    } else {
      console.log('Not Found', uuid, dirPath, name);
    }
  })

}
const getAssets = (file) => {
  const text = fs.readFileSync(file, 'utf8');
  const uuids = parseNonLinkedUuids(text);
  if (uuids.length === 0) return;
  const localAssets = parseNamedAssets(text, uuids);
  fetchMissingAssets(file, localAssets);
}

main();