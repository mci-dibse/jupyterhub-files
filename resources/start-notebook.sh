#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

### Quick and dirty logging mechanism
# Backup previous logs and delete too old log-files
mkdir -p /home/jovyan/work/.logs
if [ -f /home/jovyan/work/.logs/.jupyter.log.2 ]; then
  rm /home/jovyan/work/.logs/.jupyter.log.2
fi
if [ -f /home/jovyan/work/.logs/.jupyter.log.1 ]; then
  mv /home/jovyan/work/.logs/.jupyter.log.1 /home/jovyan/work/.logs/.jupyter.log.2
fi
if [ -f /home/jovyan/work/.logs/.jupyter.log.0 ]; then
  mv /home/jovyan/work/.logs/.jupyter.log.0 /home/jovyan/work/.logs/.jupyter.log.1
fi
if [ -f /home/jovyan/work/.logs/.jupyter.log ]; then
  mv /home/jovyan/work/.logs/.jupyter.log  /home/jovyan/work/.logs/.jupyter.log.0
fi
# Redirect stdout and stderr into a logfile
exec > /home/jovyan/work/.logs/.jupyter.log 2>&1

if [[ ! -z "${JUPYTERHUB_API_TOKEN}" ]]; then
  # launched by JupyterHub, use single-user entrypoint
  exec /usr/local/bin/start-singleuser.sh $*
else
  if [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
    . /usr/local/bin/start.sh jupyter lab $*
  else
    . /usr/local/bin/start.sh jupyter notebook $*
  fi
fi
