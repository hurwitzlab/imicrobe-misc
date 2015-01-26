CREATE TABLE metadata_type (
  metadata_type_id int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  category varchar(64) not null default '',
  category_type varchar(32),
  qiime_tag varchar(128),
  mgrast_tag varchar(128),
  tag varchar(128) not null default '',
  definition text,
  required tinyint not null default 0,
  mixs tinyint not null default 0,
  type text,
  fw_type text,
  unit text,
  unique (category, tag)
) ENGINE=InnoDB;
