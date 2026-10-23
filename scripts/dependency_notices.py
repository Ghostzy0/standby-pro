#!/usr/bin/env python3
"""Collect licence files from the packages actually resolved by Flutter pub get."""
from pathlib import Path
from urllib.parse import urljoin,urlparse,unquote
import json,re
root=Path(__file__).resolve().parent.parent
config=root/'app/.dart_tool/package_config.json'
packages=json.loads(config.read_text())['packages']
blocks=[];inventory=[];missing=[]
for package in packages:
 if package['name']=='standby_pro':continue
 folder=Path(unquote(urlparse(urljoin(config.as_uri(),package['rootUri'])).path))
 names=[folder/'LICENSE',folder/'LICENSE.md',folder/'LICENSE.txt',folder/'COPYING']
 licenses=[p for p in names if p.is_file()]
 if not licenses and package['name'].startswith('flutter_'):
  sdk_license=folder.parent.parent/'LICENSE'
  if sdk_license.is_file(): licenses=[sdk_license]
 if not licenses:
  missing.append(package['name']);continue
 version='SDK'
 pubspec=folder/'pubspec.yaml'
 if pubspec.exists():
  m=re.search(r'^version:\s*(.+)$',pubspec.read_text(),re.M)
  if m:version=m.group(1)
 inventory.append(f"- {package['name']} {version}")
 blocks.append(f"{'='*70}\n{package['name']} {version}\n"+'\n\n'.join('\n'.join(line.rstrip() for line in p.read_text(errors='replace').splitlines()) for p in licenses))
(root/'THIRD-PARTY-NOTICES.txt').write_text('Standby Pro resolved Flutter/Dart package licences\nIncludes build/test packages for completeness. Generated from package_config.\n\n'+'\n\n'.join(blocks))
(root/'docs/dependencies.md').write_text('# Resolved dependency inventory\n\nGenerated from Flutter 3.41.9 locked resolution. Full texts: [THIRD-PARTY-NOTICES.txt](../THIRD-PARTY-NOTICES.txt). Flutter builds include their own generated NOTICES file.\n\n'+'\n'.join(inventory)+'\n\nMissing licence files: '+(', '.join(missing) or 'none')+'.\n\nWeather data: Open-Meteo, CC BY 4.0; free endpoint service is noncommercial under https://open-meteo.com/en/terms. Original app source: MIT. Historical competitor reference captures are excluded from current distribution.\n')
print(f'Collected {len(inventory)} package licences; missing: {missing}')
