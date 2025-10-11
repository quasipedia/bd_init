This project uses [OCP CAD Viewer](https://github.com/bernhard-42/vscode-ocp-cad-viewer)
as default viewer.  OCP is web-based viewer, and in order to see the model you
will have to:
- Run `uv run python -m ocp_vscode` in one terminal¹ (this will start the web
server that will keep on running until it is shut down with CTRL-C).
- Point your browser to [http://localhost:3939/viewer](http://localhost:3939/viewer)
- Run the command above (`uv run TEMPLATE_PACKAGE_NAME`) in a second terminal

¹ = Some versions of OCP have a bug for which it is necessary to expressely pass
the parameter `--tree_width` when invoking it like this:

```console
uv run python -m ocp_vscode --tree_width 240
```
