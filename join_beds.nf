#!/usr/bin/env nextflow
/*
==============================
Fecha: OCT 10, 2019
Version: 0.001
Autores: Judith Ballesteros Villascán
Descripción: Join beds of predicted targets or miRNAs.
GIT Repository: https://github.com/jbv2/nf-join-beds.git
==============================
INITIALIZE PARAMETERS
==============================
Pipeline processes in brief:
Pre-Processing:
_pre1_tag_file_name
_pre2_sort_beds
Core-Processing:
_001_concatenate_beds
==============================
*/

/*
PIPELINE START
*/
/* DEFINE INPUT PATHS
/* Load feature files into channel*/
Channel
  .fromPath( "${params.input_dir}/*.bed" )
   .set{feature_files_inputs}
/*
===========================================
Process for tagging file names
===========================================
*/
/* Loading mkfiles*/
Channel
  .fromPath("mkmodules/mk-tag-filename/*")
    .toList()
    .set{mkfiles_pre1}

process _pre1_tag_file_name {
  publishDir "test/results/_pre1_tag_file_name/", mode: "copy"
  input:
    file beds from feature_files_inputs
    file mkfiles from mkfiles_pre1
    output:
     file "*.tagged.bed" into results_pre1_tag_file_name
    """
    bash runmk.sh
    """
}

/*
===========================================
Process for sorting beds
===========================================
*/
/* Prepare inputs */
results_pre1_tag_file_name
  .view()
  .toList()
  .view()
  .set{inputs_for_pre2}

  /* Load mkfiles */
  Channel
    .fromPath("mkmodules/mk-sort-bed/*")
      .toList()
      .view()
      .set{mkfiles_pre2}

  process _pre2_sort_beds{
    publishDir "test/results/_pre2_sort_beds/", mode: "copy"
    input:
    file beds from inputs_for_pre2
    file mkfiles from mkfiles_pre2
    output:
    file "*.sorted.bed" into results_pre2_sort_beds

    """
    bash runmk.sh
    """
  }

  /*
  =========================================================
  Process for concatenating beds
  =========================================================
  */
  /* Prepare inputs */
  // results_pre2_sort_beds
  //   .view()
  //   .toList()
  //   .view()
  //   .set{inputs_for_001}

  /* Load mkfiles */
  Channel
    .fromPath("mkmodules/mk-concatenate-beds/*")
      .toList()
      .view()
      .set{mkfiles_001}

  process _001_concatenate_beds{
    publishDir "test/results/_001_concatenate_beds/", mode: "copy"
    input:
    file filtered_vcfs from results_pre2_sort_beds
    file mkfiles from mkfiles_001
    output:
    file "tagged.sorted.concatenated.bed" into results_001_concatenate_beds

    """
    bash runmk.sh
    """
  }
