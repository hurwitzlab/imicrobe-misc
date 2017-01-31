update combined_assembly set peptides_file=replace(peptides_file, '\n', '');
update combined_assembly set annotations_file=replace(annotations_file, '\n', '');
update combined_assembly set nucleotides_file=replace(nucleotides_file, '\n', '');
update combined_assembly set cds_file=replace(cds_file, '\n', '');

