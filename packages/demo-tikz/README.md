# Draw a graph

Drawing is basic usage of TeX. Perhaps you know
[graphviz](https://graphviz.org/), another drawing languages:

`main.gv`:

```dot
digraph G{
 a -> b -> {c, d}
}
```

```sh
dot -Tpng -omain.png main.gv
```

![dot](https://github.com/user-attachments/assets/2ad933b7-b40b-4d13-97c0-f1db34842204)

You don't need to declare the position of node a, b, c and d.
The compiler of graphviz will calculate it:

```sh
dot main.gv
```

```dot
digraph G {
        graph [bb="0,0,126,180"];
        node [label="\N"];
        {
                c       [height=0.5,
                        pos="27,18",
                        width=0.75];
                d       [height=0.5,
                        pos="99,18",
                        width=0.75];
        }
        a       [height=0.5,
                pos="63,162",
                width=0.75];
        b       [height=0.5,
                pos="63,90",
                width=0.75];
        a -> b  [pos="e,63,108.1 63,143.7 63,136.41 63,127.73 63,119.54"];
        b -> c  [pos="e,35.304,35.147 54.65,72.765 50.425,64.548 45.192,54.373 40.419,45.093"];
        b -> d  [pos="e,90.696,35.147 71.35,72.765 75.575,64.548 80.808,54.373 85.581,45.093"];
}
```

TeX has a TikZ library named `graph drawing` to provide same feature.

```tex
\documentclass[tikz]{standalone}
\usetikzlibrary{arrows.meta, graphs, graphdrawing, shapes.geometric}
\usegdlibrary{layered}
\title{graph}
\begin{document}
\begin{tikzpicture}[rounded corners, >=Stealth, auto]
  \graph[layered layout, nodes={draw, align=center}]{%

    a -> b -> {c, d}

  };
\end{tikzpicture}
\end{document}
```

Different from graphviz, you can use powerful TeX syntax in `graph drawing`.
Run `lx build` to see this example:

![graph](https://github.com/user-attachments/assets/131a8a31-0dd4-49fa-84dd-1531c89da55c)

This example only supports LuaTeX, not pdfTeX and XeTeX.
because `graph drawing` is written in lua, not TeX.
