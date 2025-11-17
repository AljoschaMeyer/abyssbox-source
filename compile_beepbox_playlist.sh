#!/bin/bash
set -e

# Compile player/main.ts into build/player/main.js and dependencies
npx tsc -p tsconfig_playlist.json

# Combine build/player/main.js and dependencies into website/player/beepbox_player.js
npx rollup build/player/playlist.js \
	--file website/player/beepbox_playlist.js \
	--format iife \
	--output.name beepbox \
	--context exports \
	--sourcemap \
	--plugin rollup-plugin-sourcemaps \
	--plugin @rollup/plugin-node-resolve

# Minify website/player/beepbox_playlist.js into website/playlistexample/beepbox_playlist.min.js
npx terser \
	website/player/beepbox_playlist.js \
	--source-map "content='website/player/beepbox_playlist.js.map',url=beepbox_playlist.min.js.map" \
	-o website/playlistexample/beepbox_playlist.min.js \
	--define OFFLINE=false \
	--compress \
	--mangle \
	--mangle-props regex="/^_.+/;"
