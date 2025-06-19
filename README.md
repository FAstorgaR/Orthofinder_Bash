# 🔬 Pipeline de Análisis Filogenético con OrthoFinder

Este pipeline automatiza el flujo desde archivos genómicos en formato `.fna` hasta la predicción de proteínas, identificación de ortólogos y generación de un árbol filogenético utilizando:

- Prodigal (predicción de proteínas)
- OrthoFinder (detección de ortogrupos)
- MAFFT (alineamiento de ortólogos core)
- FastTree (árbol filogenético)

---

## ⚙️ Requisitos

Instalar dependencias con Conda:

```bash
conda create -n ortho_env -c bioconda -y prodigal orthofinder mafft fasttree
conda activate ortho_env
```

---

## 📂 Estructura esperada de entrada

Se espera una carpeta con genomas descargados y descomprimidos:

```
genomes_tax_<taxid>/
├── genome1.fna
├── genome2.fna
└── ...
```

---

## 🚀 Cómo usar

1. Asegúrate de tener archivos `.fna` en subcarpetas dentro de `genomes_tax_<taxid>/`.
2. Ejecuta el script del pipeline:

```bash
chmod +x run_orthofinder_pipeline.sh
./run_orthofinder_pipeline.sh
```

Este script realizará:

- Predicción de proteínas con **Prodigal**
- Ejecución de **OrthoFinder**
- Alineamiento de ortólogos de copia única con **MAFFT**
- Concatenación de alineamientos
- Construcción de un árbol filogenético con **FastTree**

---

## 📁 Archivos y resultados generados

| Archivo/carpeta                                 | Descripción                                                  |
|--------------------------------------------------|--------------------------------------------------------------|
| `proteins_faa/`                                  | Archivos `.faa` generados por Prodigal                      |
| `proteins_faa/OrthoFinder/Results_*/`            | Resultados principales de OrthoFinder                       |
| `Orthogroups.tsv`                                | Ortogrupos identificados                                     |
| `Orthogroups_SingleCopyOrthologues.txt`          | Ortólogos core (una copia por genoma)                        |
| `Single_Copy_Orthologue_Sequences/`              | FASTA individuales por ortólogo core                         |
| `*_aligned.fa`                                   | Alineamientos por ortólogo                                   |
| `concatenated_alignment.fa`                      | Superalineamiento concatenado                                |
| `tree.nwk`                                       | Árbol filogenético en formato Newick                         |

---

## 🧠 Personalización

- Cambia el número de hilos modificando la variable `THREADS` en el script.
- Puedes usar `IQ-TREE` en vez de `FastTree` para análisis más robustos.

---

## 🧪 Ejemplo de visualización

Para visualizar el árbol:

```bash
apt install figtree
figtree tree.nwk
```

O usa herramientas web como [iTOL](https://itol.embl.de/).

---

## 📚 Referencias

- [Prodigal](https://github.com/hyattpd/Prodigal)
- [OrthoFinder](https://github.com/davidemms/OrthoFinder)
- [MAFFT](https://mafft.cbrc.jp/alignment/software/)
- [FastTree](http://www.microbesonline.org/fasttree/)
