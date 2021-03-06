cwlVersion: v1.0
label: Generate phylogenetic tree
doc: Search for similar protein sequences using NCBI BLAST. The 20 top most similar sequences are aligned with Clustal Omega and feed to Simple Phylogeny tool.
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement

inputs:
  label: UniProt identifier
  doc: Enter a UniProt identifier
  default: uniprot:wap_rat
  protein: string?

outputs:
  tree:
    label: Phylogenetic tree
    doc: Newick format phylogenetic tree
    type: File
    outputSource: phylogeny/tree

steps:
  sss:
    label: NCBI BLAST
    doc: Sequence similarity search
    run: '../ncbiblast/ncbiblast.cwl'
    in:
      sequence: protein
    out: [proteins]

  sss-msa:
    label: Top 20 similar sequences
    doc: Use DbFetch to get the 20 top most similar sequences
    run: 'fetch-proteins.cwl'
    in:
      accessions: sss/proteins
    out: [sequences]

  msa:
    label: Clustal Omega
    doc: Multiple sequence alignment
    run: '../clustalo/clustalo.cwl'
    in:
      sequences: sss-msa/sequences
    out: [alignment]

  phylogeny:
    label: Simple Phylogeny
    doc: Generate phylogeny tree
    run: '../simple_phylogeny/simple_phylogeny.cwl'
    in:
      alignment: msa/alignment
    out: [tree]
