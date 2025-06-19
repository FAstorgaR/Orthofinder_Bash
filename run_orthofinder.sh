#!/bin/bash

# Pipeline completo desde archivos .fna hasta árboles filogenéticos usando OrthoFinder
# Requiere: prodigal, orthofinder, mafft, fasttree (opcional)

set -e  # salir en error
THREADS=4

echo "📁 Creando carpeta para proteínas predichas..."
mkdir -p proteins_faa

# Activar globstar para recorrer subdirectorios
shopt -s globstar

echo "🧬 Ejecutando Prodigal para predecir proteínas desde archivos .fna..."
for genome in genomes_tax_*/**/*.fna; do
  base=$(basename "$genome" .fna)
  echo "➡️ $base"
  prodigal -i "$genome" -a "proteins_faa/${base}.faa" -p single
done

echo "🚀 Ejecutando OrthoFinder..."
orthofinder -f proteins_faa -t $THREADS

# Buscar carpeta de resultados automáticamente
RESULT_DIR=$(find proteins_faa/OrthoFinder -type d -name "Results_*" | head -n 1)

echo "📂 Resultados OrthoFinder en: $RESULT_DIR"

SINGLE_COPY_FASTAS="$RESULT_DIR/Orthogroup_Sequences/Single_Copy_Orthologue_Sequences"

if [ -d "$SINGLE_COPY_FASTAS" ]; then
  echo "🧬 Alineando ortólogos de copia única con MAFFT..."
  for fasta in "$SINGLE_COPY_FASTAS"/*.fa; do
    echo "➡️ Alineando: $(basename "$fasta")"
    mafft --auto "$fasta" > "${fasta%.fa}_aligned.fa"
  done

  echo "🧪 Concatenando alineamientos..."
  cat "$SINGLE_COPY_FASTAS"/*_aligned.fa > concatenated_alignment.fa

  echo "🌳 Construyendo árbol filogenético con FastTree..."
  fasttree -lg concatenated_alignment.fa > tree.nwk

  echo "✅ Árbol generado: tree.nwk"
else
  echo "⚠️ No se encontró carpeta con ortólogos de copia única."
fi
