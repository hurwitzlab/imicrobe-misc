SET foreign_key_checks=0;

drop table if exists combined_assembly;
create table combined_assembly (
    combined_assembly_id int unsigned not null auto_increment primary key,
    project_id int unsigned not null,
    assembly_name varchar(255),
    phylum varchar(255),
    class varchar(255),
    family varchar(255),
    genus varchar(255),
    species varchar(255),
    strain varchar(255),
    pcr_amp varchar(255),
    annotations_file varchar(255),
    peptides_file varchar(255),
    nucleotides_file varchar(255),
    cds_file varchar(255),
    foreign key (project_id) references project (project_id)
) ENGINE=InnoDB;

drop table if exists combined_assembly_to_sample;
create table combined_assembly_to_sample (
    combined_assembly_to_sample_id int unsigned not null auto_increment primary key,
    combined_assembly_id int unsigned not null,
    sample_id int unsigned not null,
    foreign key (combined_assembly_id) references combined_assembly (combined_assembly_id),
    foreign key (sample_id) references sample (sample_id)
) ENGINE=InnoDB;
