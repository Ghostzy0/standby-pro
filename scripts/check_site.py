#!/usr/bin/env python3
from pathlib import Path
from html.parser import HTMLParser
from urllib.parse import urlparse
import json,sys
root=Path(__file__).resolve().parent.parent/'docs'
class Page(HTMLParser):
 def __init__(self):super().__init__();self.links=[];self.errors=[];self.title=False;self.description=False;self.canonical=False;self.lang=False;self.jsonld=False
 def handle_starttag(self,tag,attrs):
  a=dict(attrs)
  if tag=='html':self.lang=bool(a.get('lang'))
  if tag=='title':self.title=True
  if tag=='meta' and a.get('name')=='description':self.description=bool(a.get('content'))
  if tag=='link' and a.get('rel')=='canonical':self.canonical=bool(a.get('href','').startswith('https://'))
  if tag=='img' and not a.get('alt'):self.errors.append('image missing alt')
  for k in ['href','src']:
   if k in a:self.links.append(a[k])
  self.jsonld=tag=='script' and a.get('type')=='application/ld+json'
 def handle_data(self,data):
  if self.jsonld and data.strip():json.loads(data)
for path in sorted(root.glob('*.html')):
 page=Page();page.feed(path.read_text())
 for href in page.links:
  u=urlparse(href)
  if u.scheme or u.netloc or not u.path:continue
  candidate=(path.parent/u.path)
  if not candidate.exists():page.errors.append('missing relative link '+href)
 if not all([page.lang,page.title,page.description,page.canonical]):page.errors.append('missing lang/title/description/canonical')
 if page.errors:print(path.name,page.errors);sys.exit(1)
 print(f'{path.name}: metadata, JSON-LD, image labels and local links passed')
print('Static check only; no crawl, ranking, screen-reader or live deployment claim.')
