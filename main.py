from __future__ import annotations

from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel

app = FastAPI()
templates = Jinja2Templates(directory='templates')
sysinfos: list[SysInfo] = []


class SysInfo(BaseModel):
    manufacturer: str
    model: str
    serial: str
    cpu: str
    ram: str
    os: str
    disk_manufacturer: str
    disk_model: str
    disk_serial: str


@app.get('/')
async def get_sysinfo(request: Request, debug: bool = False):
    sysinfo_strs = ['\t'.join((
        info.manufacturer,
        info.model,
        info.serial,
        info.cpu,
        info.ram,
        info.os,
        info.disk_manufacturer,
        info.disk_model,
        info.disk_serial,
    )) for info in sysinfos]
    return templates.TemplateResponse('sysinfos.html', {'request': request, 'sysinfos': sysinfo_strs, 'debug': debug})


@app.post('/')
async def post_sysinfo(sysinfo: SysInfo):
    sysinfos.insert(0, sysinfo)


@app.delete('/')
async def delete_sysinfo():
    global sysinfos
    sysinfos = []

