drop table if exists ontology;
CREATE TABLE ontology (
  ontology_id int unsigned NOT NULL AUTO_INCREMENT,
  ontology_acc varchar(125) NOT NULL,
  label varchar(125) NOT NULL,
  KEY (ontology_acc),
  PRIMARY KEY (ontology_id)
) ENGINE=InnoDB;

drop table if exists sample_to_ontology;
CREATE TABLE sample_to_ontology (
  sample_to_ontology_id int unsigned NOT NULL AUTO_INCREMENT,
  sample_id int unsigned,
  ontology_id int unsigned,
  KEY (sample_id),
  KEY (ontology_id),
  PRIMARY KEY (sample_to_ontology_id),
  FOREIGN KEY (sample_id) REFERENCES sample (sample_id),
  FOREIGN KEY (ontology_id) REFERENCES ontology (ontology_id)
) ENGINE=InnoDB;
