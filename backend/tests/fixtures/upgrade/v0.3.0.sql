-- Bike Log v0.3.0 (schema revision 0022), demo/sample data made by that version's own code.
BEGIN TRANSACTION;
CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL, 
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);
INSERT INTO "alembic_version" VALUES('0022');
CREATE TABLE app_setting (
	"key" VARCHAR(64) NOT NULL, 
	value TEXT NOT NULL, 
	PRIMARY KEY ("key")
);
INSERT INTO "app_setting" VALUES('sample_data','1');
CREATE TABLE bike (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	name TEXT NOT NULL, 
	maker TEXT, 
	model TEXT, 
	year INTEGER, 
	status VARCHAR(16) NOT NULL, 
	strava_gear_id VARCHAR(32), 
	notes TEXT, 
	created_at VARCHAR(20) NOT NULL, 
	updated_at VARCHAR(20) NOT NULL, purchase_price_cents INTEGER, purchase_date VARCHAR(10), shifting VARCHAR(12), shop TEXT, deleted_at VARCHAR(20), 
	PRIMARY KEY (id), 
	CONSTRAINT ck_bike_status CHECK (status IN ('ACTIVE','RETIRED')), 
	UNIQUE (name), 
	UNIQUE (strava_gear_id), 
	UNIQUE (uuid)
);
INSERT INTO "bike" VALUES(1,'4798e7f4-8b4b-4956-942a-e7266845770e','Aurora SL','Sample','Aurora SL',2026,'ACTIVE',NULL,'Sample data (made up). Settings → Fresh start removes it.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',249900,'2026-02-27',NULL,NULL,NULL);
INSERT INTO "bike" VALUES(2,'3084c512-d705-4907-be30-1e289d66e8ab','Winter Allroad','Sample','Allroad',2023,'ACTIVE',NULL,'Sample data (made up). Settings → Fresh start removes it.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,'MECHANICAL',NULL,NULL);
CREATE TABLE change_log (
	id INTEGER NOT NULL, 
	changed_at VARCHAR(20) NOT NULL, 
	bike_id INTEGER, 
	component_id INTEGER, 
	action VARCHAR(16) NOT NULL, 
	field VARCHAR(64), 
	old_value TEXT, 
	new_value TEXT, 
	source VARCHAR(32) NOT NULL, 
	via VARCHAR(64), 
	PRIMARY KEY (id), 
	CONSTRAINT ck_change_log_target CHECK (bike_id IS NOT NULL OR component_id IS NOT NULL)
);
INSERT INTO "change_log" VALUES(1,'2026-11-14T18:52:46Z',1,NULL,'CREATED',NULL,NULL,'Aurora SL','SAMPLE','demo');
INSERT INTO "change_log" VALUES(2,'2026-11-14T18:52:46Z',NULL,1,'CREATED',NULL,NULL,'Frame and fork Aurora SL frame','SAMPLE','demo');
INSERT INTO "change_log" VALUES(3,'2026-11-14T18:52:46Z',1,1,'INSTALLED',NULL,NULL,'Aurora SL (frame) from 2026-02-27','SAMPLE','demo');
INSERT INTO "change_log" VALUES(4,'2026-11-14T18:52:46Z',2,NULL,'CREATED',NULL,NULL,'Winter Allroad','SAMPLE','demo');
INSERT INTO "change_log" VALUES(5,'2026-11-14T18:52:46Z',NULL,2,'CREATED',NULL,NULL,'Frame and fork Winter Allroad frame','SAMPLE','demo');
INSERT INTO "change_log" VALUES(6,'2026-11-14T18:52:46Z',2,2,'INSTALLED',NULL,NULL,'Winter Allroad (frame) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(7,'2026-11-14T18:52:46Z',NULL,3,'CREATED',NULL,NULL,'Front wheel DT Swiss ARC 1400 front (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(8,'2026-11-14T18:52:46Z',NULL,4,'CREATED',NULL,NULL,'Rear wheel DT Swiss ARC 1400 rear (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(9,'2026-11-14T18:52:46Z',NULL,4,'CHANGED','history before tracking','unknown','recorded','SAMPLE','demo');
INSERT INTO "change_log" VALUES(10,'2026-11-14T18:52:46Z',1,3,'INSTALLED',NULL,NULL,'Aurora SL (front wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(11,'2026-11-14T18:52:46Z',NULL,5,'CREATED',NULL,NULL,'Tire GP5000 32 mm front (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(12,'2026-11-14T18:52:46Z',NULL,5,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 front (Aurora SL) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(13,'2026-11-14T18:52:46Z',NULL,6,'CREATED',NULL,NULL,'Inner tube tube front (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(14,'2026-11-14T18:52:46Z',NULL,6,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 front (Aurora SL) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(15,'2026-11-14T18:52:46Z',1,4,'INSTALLED',NULL,NULL,'Aurora SL (rear wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(16,'2026-11-14T18:52:46Z',NULL,7,'CREATED',NULL,NULL,'Tire GP5000 32 mm rear (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(17,'2026-11-14T18:52:46Z',NULL,7,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(18,'2026-11-14T18:52:46Z',NULL,8,'CREATED',NULL,NULL,'Inner tube tube rear (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(19,'2026-11-14T18:52:46Z',NULL,8,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(20,'2026-11-14T18:52:46Z',NULL,9,'CREATED',NULL,NULL,'Front wheel Alloy front (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(21,'2026-11-14T18:52:46Z',NULL,10,'CREATED',NULL,NULL,'Rear wheel Alloy rear (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(22,'2026-11-14T18:52:46Z',2,9,'INSTALLED',NULL,NULL,'Winter Allroad (front wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(23,'2026-11-14T18:52:46Z',NULL,11,'CREATED',NULL,NULL,'Tire GP5000 32 mm front (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(24,'2026-11-14T18:52:46Z',NULL,11,'INSTALLED',NULL,NULL,'Alloy front (Winter Allroad) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(25,'2026-11-14T18:52:46Z',NULL,12,'CREATED',NULL,NULL,'Inner tube tube front (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(26,'2026-11-14T18:52:46Z',NULL,12,'INSTALLED',NULL,NULL,'Alloy front (Winter Allroad) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(27,'2026-11-14T18:52:46Z',2,10,'INSTALLED',NULL,NULL,'Winter Allroad (rear wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(28,'2026-11-14T18:52:46Z',NULL,13,'CREATED',NULL,NULL,'Tire GP5000 32 mm rear (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(29,'2026-11-14T18:52:46Z',NULL,13,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(30,'2026-11-14T18:52:46Z',NULL,14,'CREATED',NULL,NULL,'Inner tube tube rear (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(31,'2026-11-14T18:52:46Z',NULL,14,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(32,'2026-11-14T18:52:46Z',NULL,15,'CREATED',NULL,NULL,'Wheelset DT Swiss ARC 1400 wheelset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(33,'2026-11-14T18:52:46Z',1,3,'REMOVED',NULL,'Aurora SL (front wheel)','on 2026-08-20 · moved','SAMPLE','demo');
INSERT INTO "change_log" VALUES(34,'2026-11-14T18:52:46Z',1,4,'REMOVED',NULL,'Aurora SL (rear wheel)','on 2026-08-20 · moved','SAMPLE','demo');
INSERT INTO "change_log" VALUES(35,'2026-11-14T18:52:46Z',1,15,'INSTALLED',NULL,NULL,'Aurora SL (wheelset) from 2026-08-20','SAMPLE','demo');
INSERT INTO "change_log" VALUES(36,'2026-11-14T18:52:46Z',NULL,3,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 wheelset (front wheel) from 2026-08-20','SAMPLE','demo');
INSERT INTO "change_log" VALUES(37,'2026-11-14T18:52:46Z',NULL,4,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 wheelset (rear wheel) from 2026-08-20','SAMPLE','demo');
INSERT INTO "change_log" VALUES(38,'2026-11-14T18:52:46Z',NULL,16,'CREATED',NULL,NULL,'Shifters Ultegra Di2 levers','SAMPLE','demo');
INSERT INTO "change_log" VALUES(39,'2026-11-14T18:52:46Z',1,16,'INSTALLED',NULL,NULL,'Aurora SL (shifters) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(40,'2026-11-14T18:52:46Z',NULL,17,'CREATED',NULL,NULL,'Front derailleur Ultegra front derailleur','SAMPLE','demo');
INSERT INTO "change_log" VALUES(41,'2026-11-14T18:52:46Z',1,17,'INSTALLED',NULL,NULL,'Aurora SL (front derailleur) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(42,'2026-11-14T18:52:46Z',NULL,18,'CREATED',NULL,NULL,'Rear derailleur Ultegra rear derailleur','SAMPLE','demo');
INSERT INTO "change_log" VALUES(43,'2026-11-14T18:52:46Z',1,18,'INSTALLED',NULL,NULL,'Aurora SL (rear derailleur) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(44,'2026-11-14T18:52:46Z',NULL,19,'CREATED',NULL,NULL,'Pulley wheel Ultegra upper pulley (guide)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(45,'2026-11-14T18:52:46Z',NULL,19,'INSTALLED',NULL,NULL,'Ultegra rear derailleur (pulley upper) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(46,'2026-11-14T18:52:46Z',NULL,20,'CREATED',NULL,NULL,'Pulley wheel Ultegra lower pulley (tension)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(47,'2026-11-14T18:52:46Z',NULL,20,'INSTALLED',NULL,NULL,'Ultegra rear derailleur (pulley lower) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(48,'2026-11-14T18:52:46Z',NULL,21,'CREATED',NULL,NULL,'Crankset Ultegra crankset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(49,'2026-11-14T18:52:46Z',1,21,'INSTALLED',NULL,NULL,'Aurora SL (crankset) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(50,'2026-11-14T18:52:46Z',NULL,22,'CREATED',NULL,NULL,'Chainring Ultegra outer chainring 52T','SAMPLE','demo');
INSERT INTO "change_log" VALUES(51,'2026-11-14T18:52:46Z',NULL,22,'INSTALLED',NULL,NULL,'Ultegra crankset (chainring outer) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(52,'2026-11-14T18:52:46Z',NULL,23,'CREATED',NULL,NULL,'Chainring Ultegra inner chainring 36T','SAMPLE','demo');
INSERT INTO "change_log" VALUES(53,'2026-11-14T18:52:46Z',NULL,23,'INSTALLED',NULL,NULL,'Ultegra crankset (chainring inner) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(54,'2026-11-14T18:52:46Z',NULL,24,'CREATED',NULL,NULL,'Bottom bracket Ultegra bottom bracket','SAMPLE','demo');
INSERT INTO "change_log" VALUES(55,'2026-11-14T18:52:46Z',1,24,'INSTALLED',NULL,NULL,'Aurora SL (bottom bracket) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(56,'2026-11-14T18:52:46Z',NULL,25,'CREATED',NULL,NULL,'Cassette Ultegra cassette 11-34','SAMPLE','demo');
INSERT INTO "change_log" VALUES(57,'2026-11-14T18:52:46Z',NULL,25,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (cassette) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(58,'2026-11-14T18:52:46Z',NULL,26,'CREATED',NULL,NULL,'Chain Ultegra chain','SAMPLE','demo');
INSERT INTO "change_log" VALUES(59,'2026-11-14T18:52:46Z',1,26,'INSTALLED',NULL,NULL,'Aurora SL (chain) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(60,'2026-11-14T18:52:46Z',NULL,26,'CHANGED','chain rotation of bike',NULL,'Aurora SL','SAMPLE','demo');
INSERT INTO "change_log" VALUES(61,'2026-11-14T18:52:46Z',NULL,27,'CREATED',NULL,NULL,'Quick link Ultegra quick link','SAMPLE','demo');
INSERT INTO "change_log" VALUES(62,'2026-11-14T18:52:46Z',NULL,27,'INSTALLED',NULL,NULL,'Ultegra chain (quick link) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(63,'2026-11-14T18:52:46Z',NULL,28,'CREATED',NULL,NULL,'Brake circuit (hydraulic) Ultegra front brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(64,'2026-11-14T18:52:46Z',1,28,'INSTALLED',NULL,NULL,'Aurora SL (front brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(65,'2026-11-14T18:52:46Z',NULL,29,'CREATED',NULL,NULL,'Brake circuit (hydraulic) Ultegra rear brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(66,'2026-11-14T18:52:46Z',1,29,'INSTALLED',NULL,NULL,'Aurora SL (rear brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(67,'2026-11-14T18:52:46Z',NULL,30,'CREATED',NULL,NULL,'Brake pads Ultegra front pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(68,'2026-11-14T18:52:46Z',1,30,'INSTALLED',NULL,NULL,'Aurora SL (front pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(69,'2026-11-14T18:52:46Z',NULL,31,'CREATED',NULL,NULL,'Brake pads Ultegra rear pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(70,'2026-11-14T18:52:46Z',1,31,'INSTALLED',NULL,NULL,'Aurora SL (rear pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(71,'2026-11-14T18:52:46Z',NULL,32,'CREATED',NULL,NULL,'Brake rotor Ultegra front rotor 160 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(72,'2026-11-14T18:52:46Z',NULL,32,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 front (Aurora SL) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(73,'2026-11-14T18:52:46Z',NULL,33,'CREATED',NULL,NULL,'Brake rotor Ultegra rear rotor 140 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(74,'2026-11-14T18:52:46Z',NULL,33,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(75,'2026-11-14T18:52:46Z',NULL,34,'CREATED',NULL,NULL,'Battery (Di2/AXS) Ultegra Di2 battery','SAMPLE','demo');
INSERT INTO "change_log" VALUES(76,'2026-11-14T18:52:46Z',1,34,'INSTALLED',NULL,NULL,'Aurora SL (battery) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(77,'2026-11-14T18:52:46Z',NULL,19,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(78,'2026-11-14T18:52:46Z',NULL,29,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(79,'2026-11-14T18:52:46Z',NULL,31,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(80,'2026-11-14T18:52:46Z',NULL,22,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(81,'2026-11-14T18:52:46Z',NULL,32,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(82,'2026-11-14T18:52:46Z',NULL,17,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(83,'2026-11-14T18:52:46Z',NULL,25,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(84,'2026-11-14T18:52:46Z',NULL,27,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(85,'2026-11-14T18:52:46Z',NULL,20,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(86,'2026-11-14T18:52:46Z',NULL,30,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(87,'2026-11-14T18:52:46Z',NULL,23,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(88,'2026-11-14T18:52:46Z',NULL,33,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(89,'2026-11-14T18:52:46Z',NULL,34,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(90,'2026-11-14T18:52:46Z',NULL,16,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(91,'2026-11-14T18:52:46Z',NULL,18,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(92,'2026-11-14T18:52:46Z',NULL,26,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(93,'2026-11-14T18:52:46Z',NULL,28,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(94,'2026-11-14T18:52:46Z',NULL,21,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(95,'2026-11-14T18:52:46Z',NULL,24,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(96,'2026-11-14T18:52:46Z',NULL,35,'CREATED',NULL,NULL,'Shifters GRX levers','SAMPLE','demo');
INSERT INTO "change_log" VALUES(97,'2026-11-14T18:52:46Z',2,35,'INSTALLED',NULL,NULL,'Winter Allroad (shifters) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(98,'2026-11-14T18:52:46Z',NULL,36,'CREATED',NULL,NULL,'Rear derailleur GRX rear derailleur','SAMPLE','demo');
INSERT INTO "change_log" VALUES(99,'2026-11-14T18:52:46Z',2,36,'INSTALLED',NULL,NULL,'Winter Allroad (rear derailleur) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(100,'2026-11-14T18:52:46Z',NULL,37,'CREATED',NULL,NULL,'Pulley wheel GRX upper pulley (guide)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(101,'2026-11-14T18:52:46Z',NULL,37,'INSTALLED',NULL,NULL,'GRX rear derailleur (pulley upper) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(102,'2026-11-14T18:52:46Z',NULL,38,'CREATED',NULL,NULL,'Pulley wheel GRX lower pulley (tension)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(103,'2026-11-14T18:52:46Z',NULL,38,'INSTALLED',NULL,NULL,'GRX rear derailleur (pulley lower) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(104,'2026-11-14T18:52:46Z',NULL,39,'CREATED',NULL,NULL,'Crankset GRX crankset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(105,'2026-11-14T18:52:46Z',2,39,'INSTALLED',NULL,NULL,'Winter Allroad (crankset) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(106,'2026-11-14T18:52:46Z',NULL,40,'CREATED',NULL,NULL,'Chainring GRX chainring 40T','SAMPLE','demo');
INSERT INTO "change_log" VALUES(107,'2026-11-14T18:52:46Z',NULL,40,'INSTALLED',NULL,NULL,'GRX crankset (chainring outer) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(108,'2026-11-14T18:52:46Z',NULL,41,'CREATED',NULL,NULL,'Bottom bracket GRX bottom bracket','SAMPLE','demo');
INSERT INTO "change_log" VALUES(109,'2026-11-14T18:52:46Z',2,41,'INSTALLED',NULL,NULL,'Winter Allroad (bottom bracket) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(110,'2026-11-14T18:52:46Z',NULL,42,'CREATED',NULL,NULL,'Cassette GRX cassette 10-45','SAMPLE','demo');
INSERT INTO "change_log" VALUES(111,'2026-11-14T18:52:46Z',NULL,42,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (cassette) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(112,'2026-11-14T18:52:46Z',NULL,43,'CREATED',NULL,NULL,'Chain GRX chain','SAMPLE','demo');
INSERT INTO "change_log" VALUES(113,'2026-11-14T18:52:46Z',2,43,'INSTALLED',NULL,NULL,'Winter Allroad (chain) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(114,'2026-11-14T18:52:46Z',NULL,43,'CHANGED','chain rotation of bike',NULL,'Winter Allroad','SAMPLE','demo');
INSERT INTO "change_log" VALUES(115,'2026-11-14T18:52:46Z',NULL,44,'CREATED',NULL,NULL,'Quick link GRX quick link','SAMPLE','demo');
INSERT INTO "change_log" VALUES(116,'2026-11-14T18:52:46Z',NULL,44,'INSTALLED',NULL,NULL,'GRX chain (quick link) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(117,'2026-11-14T18:52:46Z',NULL,45,'CREATED',NULL,NULL,'Brake circuit (hydraulic) GRX front brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(118,'2026-11-14T18:52:46Z',2,45,'INSTALLED',NULL,NULL,'Winter Allroad (front brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(119,'2026-11-14T18:52:46Z',NULL,46,'CREATED',NULL,NULL,'Brake circuit (hydraulic) GRX rear brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(120,'2026-11-14T18:52:46Z',2,46,'INSTALLED',NULL,NULL,'Winter Allroad (rear brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(121,'2026-11-14T18:52:46Z',NULL,47,'CREATED',NULL,NULL,'Brake pads GRX front pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(122,'2026-11-14T18:52:46Z',2,47,'INSTALLED',NULL,NULL,'Winter Allroad (front pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(123,'2026-11-14T18:52:46Z',NULL,48,'CREATED',NULL,NULL,'Brake pads GRX rear pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(124,'2026-11-14T18:52:46Z',2,48,'INSTALLED',NULL,NULL,'Winter Allroad (rear pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(125,'2026-11-14T18:52:46Z',NULL,49,'CREATED',NULL,NULL,'Brake rotor GRX front rotor 160 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(126,'2026-11-14T18:52:46Z',NULL,49,'INSTALLED',NULL,NULL,'Alloy front (Winter Allroad) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(127,'2026-11-14T18:52:46Z',NULL,50,'CREATED',NULL,NULL,'Brake rotor GRX rear rotor 160 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(128,'2026-11-14T18:52:46Z',NULL,50,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(129,'2026-11-14T18:52:46Z',NULL,51,'CREATED',NULL,NULL,'Shift cable GRX rear shift cable','SAMPLE','demo');
INSERT INTO "change_log" VALUES(130,'2026-11-14T18:52:46Z',2,51,'INSTALLED',NULL,NULL,'Winter Allroad (shift cable rear) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(131,'2026-11-14T18:52:46Z',NULL,52,'CREATED',NULL,NULL,'Shift housing GRX rear shift housing','SAMPLE','demo');
INSERT INTO "change_log" VALUES(132,'2026-11-14T18:52:46Z',2,52,'INSTALLED',NULL,NULL,'Winter Allroad (shift housing rear) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(133,'2026-11-14T18:52:46Z',NULL,53,'CREATED',NULL,NULL,'Inner tube Sample Road tube 700×28-32','SAMPLE','demo');
INSERT INTO "change_log" VALUES(134,'2026-11-14T18:52:46Z',NULL,8,'REMOVED',NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tube)','on 2026-08-22T10:00:00Z · Awaiting inspection or repair','SAMPLE','demo');
INSERT INTO "change_log" VALUES(135,'2026-11-14T18:52:46Z',NULL,8,'CHANGED','state when not installed','Stored as a reusable spare','Awaiting inspection or repair','SAMPLE','demo');
INSERT INTO "change_log" VALUES(136,'2026-11-14T18:52:46Z',NULL,53,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tube) from 2026-08-22T10:00:00Z','SAMPLE','demo');
CREATE TABLE "component" (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	component_type VARCHAR(32) NOT NULL, 
	label TEXT NOT NULL, 
	product_id INTEGER, 
	serial_number TEXT, 
	prior_usage VARCHAR(16) NOT NULL, 
	purchase_date VARCHAR(10), 
	price_cents INTEGER, 
	status VARCHAR(16) NOT NULL, 
	retired_on VARCHAR(10), 
	retire_reason TEXT, 
	notes TEXT, 
	created_at VARCHAR(20) NOT NULL, 
	updated_at VARCHAR(20) NOT NULL, specs_json TEXT DEFAULT '{}' NOT NULL, disposition VARCHAR(20) DEFAULT 'STORED' NOT NULL, disposition_on VARCHAR(10), purchase_session_id INTEGER, from_stock_txn_id INTEGER, storage_location TEXT, tire_setup VARCHAR(12), bundle_id INTEGER REFERENCES purchase_bundle (id), pressure_note TEXT, mark TEXT, rotation_bike_id INTEGER REFERENCES bike (id), warranty_until VARCHAR(10), shop TEXT, 
	PRIMARY KEY (id), 
	CONSTRAINT ck_component_prior_usage CHECK (prior_usage IN ('NEW','RECORDED','UNKNOWN')), 
	CONSTRAINT ck_component_status CHECK (status IN ('ACTIVE','RETIRED')), 
	FOREIGN KEY(product_id) REFERENCES product (id), 
	UNIQUE (uuid)
);
INSERT INTO "component" VALUES(1,'b44c9572-97dc-4644-bd54-5c7ceecef538','FRAME','Aurora SL frame',NULL,NULL,'RECORDED',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(2,'b966a176-109b-40dc-acdd-9526b02a1a7d','FRAME','Winter Allroad frame',NULL,NULL,'RECORDED',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(3,'8919c9b4-ad5f-459e-b504-bf856b41d660','FRONT_WHEEL','DT Swiss ARC 1400 front (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(4,'e71a109e-dbbc-4577-bdd6-be1975ac5012','REAR_WHEEL','DT Swiss ARC 1400 rear (Aurora SL)',NULL,NULL,'RECORDED','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(5,'ebe9db3d-134f-4cdf-a02a-a1e6b81afdf1','TIRE','GP5000 32 mm front (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(6,'6e5d4ab1-802d-4b0a-a335-badb00237834','INNER_TUBE','tube front (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(7,'80f7c20b-a68f-4549-997c-8b8a84848ae6','TIRE','GP5000 32 mm rear (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(8,'93398b40-48ba-49f3-8b42-2816e3f12e2f','INNER_TUBE','tube rear (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','AWAITING_SERVICE','2026-08-22',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(9,'5c6e3092-3b7a-4009-9e85-eb5916f52eac','FRONT_WHEEL','Alloy front (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(10,'30801a83-658f-4691-8f8d-890800fc6469','REAR_WHEEL','Alloy rear (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(11,'d0a6e711-6d99-4ad2-bb61-2fe3c382474e','TIRE','GP5000 32 mm front (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(12,'913e802f-c755-4dd6-a489-7a397066b45f','INNER_TUBE','tube front (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(13,'4d8c2308-9eaa-4224-8796-ee96b3bc95c8','TIRE','GP5000 32 mm rear (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(14,'ae18fe89-718a-4c36-ac39-6c8b7000b30e','INNER_TUBE','tube rear (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(15,'d4693298-0230-491b-8ae1-7f27d8118057','WHEELSET','DT Swiss ARC 1400 wheelset',NULL,NULL,'NEW',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(16,'a4ae8226-3611-459b-81ee-7fd9ec170a71','SHIFTERS','Ultegra Di2 levers',1,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(17,'94aec0ab-4621-48a4-ab1c-daaa009f155f','FRONT_DERAILLEUR','Ultegra front derailleur',2,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(18,'c200f7ac-d0d2-4c5c-a51c-18293ed05150','REAR_DERAILLEUR','Ultegra rear derailleur',3,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(19,'00d9d57a-8f52-4c50-b895-563f3c2ee823','PULLEY_WHEEL','Ultegra upper pulley (guide)',4,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(20,'11eb12ef-266a-4679-8dc1-5eace60f61fb','PULLEY_WHEEL','Ultegra lower pulley (tension)',5,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(21,'c1cb9ae0-558f-4c75-860c-79d08afb9f37','CRANKSET','Ultegra crankset',6,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(22,'9729189e-0feb-44b4-8822-5091b45acf17','CHAINRING','Ultegra outer chainring 52T',7,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(23,'9110bbf7-9e2a-4d9a-adea-453b69bbc428','CHAINRING','Ultegra inner chainring 36T',8,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(24,'61dfb0d4-5de7-4815-a3f2-c6758d41a053','BOTTOM_BRACKET','Ultegra bottom bracket',9,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(25,'7bcda6cd-8319-4508-abde-8dce13541581','CASSETTE','Ultegra cassette 11-34',10,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(26,'76c5b374-8fbe-4384-a072-18e34cb930a3','CHAIN','Ultegra chain',11,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,1,NULL,NULL);
INSERT INTO "component" VALUES(27,'9d919346-f3a8-4d4c-a841-391ab55c4c14','QUICK_LINK','Ultegra quick link',12,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(28,'86fa329b-e1d8-497b-8daa-e302ad31d3ea','BRAKE_CIRCUIT','Ultegra front brake',13,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(29,'09090fc7-cbee-4eb9-90c6-7713eca45dd0','BRAKE_CIRCUIT','Ultegra rear brake',14,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(30,'a2e96792-160c-4bb6-952c-7fd47fa49f50','BRAKE_PADS','Ultegra front pads',15,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(31,'d35fc0b7-5d0c-40ee-a1c5-fe9ce58c95d3','BRAKE_PADS','Ultegra rear pads',15,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(32,'49da6b0e-3fcb-4565-9733-4ef61b41fe00','BRAKE_ROTOR','Ultegra front rotor 160 mm',16,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(33,'ce0722fc-1e10-48ba-88d1-44870d6beb2d','BRAKE_ROTOR','Ultegra rear rotor 140 mm',17,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(34,'4bab8dc8-8e9a-4d61-938b-384403c2a42e','BATTERY','Ultegra Di2 battery',18,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(35,'7b1cfdcb-e6e9-4f46-a757-b0b914d2edbb','SHIFTERS','GRX levers',19,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(36,'1f233daa-0239-49ce-8183-941f74a85f18','REAR_DERAILLEUR','GRX rear derailleur',20,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(37,'74806971-4fbf-4058-b950-7b8d314ed958','PULLEY_WHEEL','GRX upper pulley (guide)',21,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(38,'44205ad7-df5b-417e-abe8-35bc7e1eba53','PULLEY_WHEEL','GRX lower pulley (tension)',22,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(39,'6759baaa-9d12-4b55-abb2-fd847f9713b5','CRANKSET','GRX crankset',23,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(40,'86ab761e-e275-4144-b898-79f5176372ac','CHAINRING','GRX chainring 40T',24,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(41,'f94d43ed-4f5f-41ed-9da8-6c1c37d48ba7','BOTTOM_BRACKET','GRX bottom bracket',9,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(42,'c729fe67-934c-42fa-959b-6063597a52eb','CASSETTE','GRX cassette 10-45',25,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(43,'0ddee542-3986-4cab-a7e6-05b3e27adced','CHAIN','GRX chain',11,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,2,NULL,NULL);
INSERT INTO "component" VALUES(44,'0eadea48-0e23-4ffa-a162-96380ffe3065','QUICK_LINK','GRX quick link',12,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(45,'a4b5a30a-53fd-44d9-a4c9-7d5f834a3d40','BRAKE_CIRCUIT','GRX front brake',26,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(46,'aabf0e05-f2ec-492c-96f3-4883fc7a47c1','BRAKE_CIRCUIT','GRX rear brake',27,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(47,'94386e73-1c7a-4b76-ae09-d97e3e0df18b','BRAKE_PADS','GRX front pads',15,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(48,'ee6a6df8-441f-4ba5-ba18-1167f582ba07','BRAKE_PADS','GRX rear pads',15,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(49,'180a595d-02f5-4959-98c5-ee18877bbdcb','BRAKE_ROTOR','GRX front rotor 160 mm',28,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(50,'a30f270e-242d-4567-ba91-12781f89472e','BRAKE_ROTOR','GRX rear rotor 160 mm',28,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(51,'3ecb080f-37ee-4a47-9532-7105b71bd60b','SHIFT_CABLE','GRX rear shift cable',29,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(52,'856ee98f-bbfd-40cf-b143-a2c7428f2551','SHIFT_HOUSING','GRX rear shift housing',30,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(53,'c0debfac-0f1c-412b-a369-8479d0c2c272','INNER_TUBE','Sample Road tube 700×28-32',31,NULL,'NEW',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','{}','STORED',NULL,NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
CREATE TABLE component_disposition (
	id INTEGER NOT NULL, 
	component_id INTEGER NOT NULL, 
	disposition VARCHAR(20) NOT NULL, 
	previous_disposition VARCHAR(20), 
	effective_on VARCHAR(10) NOT NULL, 
	note TEXT, 
	work_session_id INTEGER, 
	created_at VARCHAR(20) NOT NULL, 
	voided_at VARCHAR(20), 
	PRIMARY KEY (id), 
	FOREIGN KEY(component_id) REFERENCES component (id), 
	FOREIGN KEY(work_session_id) REFERENCES work_session (id)
);
INSERT INTO "component_disposition" VALUES(1,8,'AWAITING_SERVICE','STORED','2026-08-22','pinch flat',NULL,'2026-11-14T18:52:46Z',NULL);
CREATE TABLE consumable (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	kind VARCHAR(24) NOT NULL, 
	name TEXT NOT NULL, 
	maker TEXT, 
	unit VARCHAR(16) NOT NULL, 
	track_stock BOOLEAN NOT NULL, 
	notes TEXT, 
	created_at VARCHAR(20) NOT NULL, tracking_mode VARCHAR(8) DEFAULT 'BULK' NOT NULL, container_size FLOAT, component_type VARCHAR(32), product_id INTEGER, unit_note TEXT, storage_location TEXT, min_stock FLOAT, 
	PRIMARY KEY (id), 
	UNIQUE (name), 
	UNIQUE (uuid)
);
INSERT INTO "consumable" VALUES(1,'591b25d4-3648-4005-a569-1eb8aecb9280','WAX','Hot wax (sample)',NULL,'g',1,NULL,'2026-11-14T18:52:46Z','BULK',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable" VALUES(2,'9a1ecec6-fa7a-47c4-bd3f-136c72485396','WAX','Wax drip (sample)',NULL,'ml',0,NULL,'2026-11-14T18:52:46Z','BULK',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable" VALUES(3,'056df2af-35df-451c-9ff3-c795aff0ce91','PART','Inner tube — Sample Road tube 700×28-32',NULL,'tube',1,NULL,'2026-11-14T18:52:46Z','COUNTED',NULL,'INNER_TUBE',31,'one tube','Garage shelf',2.0);
CREATE TABLE "consumable_txn" (
	id INTEGER NOT NULL, 
	consumable_id INTEGER NOT NULL, 
	kind VARCHAR(16) NOT NULL, 
	qty FLOAT, 
	occurred_on VARCHAR(10) NOT NULL, 
	maintenance_event_id INTEGER, 
	cost_cents INTEGER, 
	note TEXT, 
	created_at VARCHAR(20) NOT NULL, 
	work_session_id INTEGER, 
	component_id INTEGER, 
	packages INTEGER, 
	voided_at VARCHAR(20), shop TEXT, 
	PRIMARY KEY (id), 
	CONSTRAINT ck_consumable_txn_kind CHECK (kind IN ('PURCHASE','USE','RETURN','ADJUST')), 
	FOREIGN KEY(maintenance_event_id) REFERENCES maintenance_event (id), 
	FOREIGN KEY(consumable_id) REFERENCES consumable (id)
);
INSERT INTO "consumable_txn" VALUES(1,1,'PURCHASE',500.0,'2026-08-16',NULL,3999,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(2,3,'PURCHASE',3.0,'2026-08-16',NULL,2097,NULL,'2026-11-14T18:52:46Z',NULL,NULL,3,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(3,1,'USE',30.0,'2026-08-19',1,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(4,2,'USE',NULL,'2026-09-05',4,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(5,1,'USE',30.0,'2026-09-20',5,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(6,3,'USE',1.0,'2026-08-22',NULL,NULL,'taken from stock to install','2026-11-14T18:52:46Z',NULL,53,NULL,NULL,NULL);
CREATE TABLE import_batch (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	source_kind VARCHAR(16) NOT NULL, 
	source_account VARCHAR(64) NOT NULL, 
	file_name TEXT, 
	file_sha256 VARCHAR(64), 
	status VARCHAR(16) NOT NULL, 
	rows_total INTEGER, 
	cursor_row INTEGER NOT NULL, 
	counts_json TEXT NOT NULL, 
	error TEXT, 
	started_at VARCHAR(20) NOT NULL, 
	finished_at VARCHAR(20), 
	PRIMARY KEY (id), 
	CONSTRAINT ck_import_status CHECK (status IN ('RUNNING','COMPLETED','FAILED')), 
	UNIQUE (uuid)
);
CREATE TABLE installation (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	component_id INTEGER NOT NULL, 
	bike_id INTEGER, 
	parent_component_id INTEGER, 
	slot VARCHAR(32) NOT NULL, 
	installed_at VARCHAR(20) NOT NULL, 
	installed_utc VARCHAR(20) NOT NULL, 
	removed_at VARCHAR(20), 
	removed_utc VARCHAR(20), 
	removal_reason TEXT, 
	note TEXT, 
	voided_at VARCHAR(20), 
	void_reason TEXT, 
	created_at VARCHAR(20) NOT NULL, removal_outcome VARCHAR(20), removal_undone_at VARCHAR(20), install_session_id INTEGER, removal_session_id INTEGER, 
	PRIMARY KEY (id), 
	CONSTRAINT ck_installation_target CHECK ((bike_id IS NULL) <> (parent_component_id IS NULL)), 
	CONSTRAINT ck_installation_order CHECK (removed_utc IS NULL OR removed_utc > installed_utc), 
	FOREIGN KEY(bike_id) REFERENCES bike (id), 
	FOREIGN KEY(component_id) REFERENCES component (id), 
	FOREIGN KEY(parent_component_id) REFERENCES component (id), 
	UNIQUE (uuid)
);
INSERT INTO "installation" VALUES(1,'7ccf7124-17fe-415a-8a0c-acac614b2580',1,1,NULL,'FRAME','2026-02-27','2026-02-26T23:00:00Z',NULL,NULL,NULL,'Added with the bike (frame and fork are parts)',NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(2,'b4f8609d-a3c4-43f2-b8e2-26342b0e8c57',2,2,NULL,'FRAME','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,'Added with the bike (frame and fork are parts)',NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(3,'48ef244b-6046-4cd0-9154-1a66aab979e9',3,1,NULL,'FRONT_WHEEL','2026-08-19','2026-08-18T22:00:00Z','2026-08-20','2026-08-19T22:00:00Z','put into a wheelset',NULL,NULL,NULL,'2026-11-14T18:52:46Z','MOVED',NULL,NULL,NULL);
INSERT INTO "installation" VALUES(4,'c4783018-1369-40b0-9ebc-5934dcc72839',5,NULL,3,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(5,'decf6f4d-e67d-4209-8f2d-58c65596c01a',6,NULL,3,'TUBE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(6,'7a98d5b5-ae94-4690-a5a9-1dabe3bdf109',4,1,NULL,'REAR_WHEEL','2026-08-19','2026-08-18T22:00:00Z','2026-08-20','2026-08-19T22:00:00Z','put into a wheelset',NULL,NULL,NULL,'2026-11-14T18:52:46Z','MOVED',NULL,NULL,NULL);
INSERT INTO "installation" VALUES(7,'a0a3a3fc-61c9-43cc-b095-a9e0b934cdcd',7,NULL,4,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(8,'622e8d78-8525-4329-ad41-873e4b6f737c',8,NULL,4,'TUBE','2026-08-19','2026-08-18T22:00:00Z','2026-08-22T10:00:00Z','2026-08-22T10:00:00Z','pinch flat',NULL,NULL,NULL,'2026-11-14T18:52:46Z','AWAITING_SERVICE',NULL,NULL,NULL);
INSERT INTO "installation" VALUES(9,'dabb7c8c-2e7a-46bb-b0e9-239f3f92ddd7',9,2,NULL,'FRONT_WHEEL','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(10,'b350f205-6c29-4cfe-8728-4423dc135343',11,NULL,9,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(11,'0fa97ea1-4d32-4ac3-aea7-1a39c41192cc',12,NULL,9,'TUBE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(12,'c3d40318-86bf-4c98-b543-0ce0a2c4a2b0',10,2,NULL,'REAR_WHEEL','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(13,'921c81ec-5208-48f5-bf7e-99f4375f4749',13,NULL,10,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(14,'bdc0ef81-1b39-4674-83c8-4262ac370366',14,NULL,10,'TUBE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(15,'2719341a-cdf9-4287-b7ae-e145f3647d18',15,1,NULL,'WHEELSET','2026-08-20','2026-08-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(16,'a09b7d28-1537-4963-8a4b-81b1c5ce0fb1',3,NULL,15,'FRONT_WHEEL','2026-08-20','2026-08-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(17,'a1c06d38-e525-43c1-9402-cfc148e08039',4,NULL,15,'REAR_WHEEL','2026-08-20','2026-08-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(18,'d1efbbc1-df1e-4efe-b211-35d3b2a9149b',16,1,NULL,'SHIFTERS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(19,'f5814b75-5aca-47cd-b544-ceca446bff40',17,1,NULL,'FRONT_DERAILLEUR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(20,'445e4591-06ed-406b-828f-62de6fdc41c3',18,1,NULL,'REAR_DERAILLEUR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(21,'a9c82fc4-e1e7-4933-94eb-0bd92d77f773',19,NULL,18,'PULLEY_UPPER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(22,'48ecccc2-1a48-4216-98d9-7f58e1203fdf',20,NULL,18,'PULLEY_LOWER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(23,'258931e4-b3fc-4c94-af58-7a8b4c6096d0',21,1,NULL,'CRANKSET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(24,'5502e270-ef4f-4964-a81f-689d4f5102b4',22,NULL,21,'CHAINRING_OUTER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(25,'6d96856e-65cb-4bab-a125-266c2fff6590',23,NULL,21,'CHAINRING_INNER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(26,'3b713634-e8e3-4ac5-a660-698db58ccfb3',24,1,NULL,'BOTTOM_BRACKET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(27,'0b56e4e1-30a8-4fe6-8097-38bd32fd9d47',25,NULL,4,'CASSETTE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(28,'59d14aef-2e58-4669-9beb-5868ef88c4c0',26,1,NULL,'CHAIN','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(29,'c96a9506-0852-46a4-913e-70354feba785',27,NULL,26,'QUICK_LINK','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(30,'19a71d0b-3c6e-4217-bc2c-51300b4bae5b',28,1,NULL,'FRONT_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(31,'ed8f6460-45cc-4618-aae8-6501e152e254',29,1,NULL,'REAR_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(32,'365a148b-c7df-4038-9e0d-77cef91c4a88',30,1,NULL,'FRONT_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(33,'4390d997-8f19-4ef2-9071-49b3b282531d',31,1,NULL,'REAR_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(34,'8c622f7d-a7fc-4621-88aa-113501ea0b47',32,NULL,3,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(35,'ce20527a-0ade-4321-94b6-20f00956c7e4',33,NULL,4,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(36,'f01beb1d-66ce-4fc4-9730-5cfd10ed0f9f',34,1,NULL,'BATTERY','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(37,'30d66002-6edf-480b-a08c-3bbad01a2d65',35,2,NULL,'SHIFTERS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(38,'c8587037-b55a-4292-b05e-3fae0b9b0e94',36,2,NULL,'REAR_DERAILLEUR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(39,'648e6eff-edc0-4acf-9a1a-400e1a17b655',37,NULL,36,'PULLEY_UPPER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(40,'03a0a053-a4e3-4951-9c72-0e278a7ec5e1',38,NULL,36,'PULLEY_LOWER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(41,'0b74c4fb-448a-473d-859d-67425fca02f8',39,2,NULL,'CRANKSET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(42,'6aa02ce5-0266-4873-9162-88f231a5cd85',40,NULL,39,'CHAINRING_OUTER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(43,'eb2dbd96-8dee-40bd-8b6c-2b64aee70de3',41,2,NULL,'BOTTOM_BRACKET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(44,'9e73137a-ae84-45dd-bfa4-02fd506a40e5',42,NULL,10,'CASSETTE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(45,'62f0c794-31f5-4946-8043-d2a15e12cb03',43,2,NULL,'CHAIN','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(46,'46bef1c6-2377-450c-9a53-34a80b5a5d48',44,NULL,43,'QUICK_LINK','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(47,'d42ba5b2-529d-47bd-baf2-cbfed0c6dbb2',45,2,NULL,'FRONT_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(48,'67bfdf1e-9bc7-4e70-856d-285b79ba58d3',46,2,NULL,'REAR_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(49,'7584695d-2385-4d81-8b2b-5c1e715077e0',47,2,NULL,'FRONT_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(50,'c7ebae5a-fe3d-4c55-b6ab-5d7d2d3b2172',48,2,NULL,'REAR_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(51,'6b8cc453-9b95-4950-bb1b-edae258781b0',49,NULL,9,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(52,'4035e496-91df-4e1c-a858-dcd2792009a8',50,NULL,10,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(53,'36d1d9f9-af32-466d-a652-45a79e270797',51,2,NULL,'SHIFT_CABLE_REAR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(54,'9d1a60fa-83a8-4260-9da5-e2c675e37957',52,2,NULL,'SHIFT_HOUSING_REAR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(55,'3c3404fb-bd60-4078-bdee-f9d9b8b94a63',53,NULL,4,'TUBE','2026-08-22T10:00:00Z','2026-08-22T10:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL);
CREATE TABLE journal_entry (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	bike_id INTEGER, 
	component_id INTEGER, 
	entry_on VARCHAR(10) NOT NULL, 
	kind VARCHAR(8) NOT NULL, 
	text TEXT NOT NULL, 
	resolved_on VARCHAR(10), 
	created_at VARCHAR(20) NOT NULL, 
	updated_at VARCHAR(20), 
	voided_at VARCHAR(20), 
	void_reason TEXT, ride_id INTEGER REFERENCES ride (id), incident_type VARCHAR(16), incident_group VARCHAR(36), affected TEXT, repair VARCHAR(12), repair_text TEXT, repaired_on VARCHAR(10), repair_session_id INTEGER REFERENCES work_session (id), 
	PRIMARY KEY (id), 
	CONSTRAINT ck_journal_kind CHECK (kind IN ('NOTE','ISSUE')), 
	CONSTRAINT ck_journal_target CHECK (bike_id IS NOT NULL OR component_id IS NOT NULL), 
	FOREIGN KEY(bike_id) REFERENCES bike (id), 
	FOREIGN KEY(component_id) REFERENCES component (id), 
	UNIQUE (uuid)
);
INSERT INTO "journal_entry" VALUES(1,'62fb089e-3ca2-4a1c-8034-295f973a2c61',1,8,'2026-08-22','ISSUE','Pinch flat on a pothole, swapped the tube at the roadside.','2026-08-22','2026-11-14T18:52:46Z',NULL,NULL,NULL,1,'FLAT','212b361a-bc5b-4f30-8972-ab5c26255b85',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "journal_entry" VALUES(2,'50072e04-e097-4cd1-9102-11e6346120be',2,NULL,'2026-09-27','ISSUE','Slid out on wet leaves in a corner; scraped bar tape and rear derailleur.',NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,18,'CRASH','05673894-790c-4f80-a386-af6db52a52d8',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "journal_entry" VALUES(3,'0e48dcda-f8c5-4231-8bec-1e29b788d16e',1,21,'2026-10-15','ISSUE','Creak under load from the bottom bracket area.',NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,25,'DEFECT','85bb42a0-d339-413f-8d52-0e3d8ab938bb',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "journal_entry" VALUES(4,'e5e927e3-e7e0-4bc2-9f38-ef6c2c7f48a4',1,NULL,'2026-08-19','NOTE','Fitted 32 mm tires; clearance is fine.',NULL,'2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
CREATE TABLE maintenance_event (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	action_code VARCHAR(32) NOT NULL, 
	component_id INTEGER, 
	bike_id INTEGER, 
	performed_at VARCHAR(20) NOT NULL, 
	performed_on VARCHAR(10) NOT NULL, 
	sort_utc VARCHAR(20) NOT NULL, 
	symptom TEXT, 
	work_done TEXT, 
	outcome TEXT, 
	measurement_value FLOAT, 
	measurement_unit VARCHAR(16), 
	consumable_id INTEGER, 
	consumable_qty FLOAT, 
	cost_cents INTEGER, 
	notes TEXT, 
	batch_ref VARCHAR(36), 
	voided_at VARCHAR(20), 
	void_reason TEXT, 
	created_at VARCHAR(20) NOT NULL, work_session_id INTEGER, shop TEXT, 
	PRIMARY KEY (id), 
	FOREIGN KEY(bike_id) REFERENCES bike (id), 
	FOREIGN KEY(component_id) REFERENCES component (id), 
	FOREIGN KEY(consumable_id) REFERENCES consumable (id), 
	UNIQUE (uuid)
);
INSERT INTO "maintenance_event" VALUES(1,'38f0aa2d-c19b-4974-b6df-55fb1295b94b','WAX_HOT',26,1,'2026-08-19','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,1,30.0,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(2,'a9acdc76-1e3b-4584-98d5-5a2dc376c50b','LUBE',43,2,'2026-08-19','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'wet lube for winter',NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(3,'3fc69e21-73b6-4b58-a993-4e82901c3eb7','BATTERY_CHARGE',34,1,'2026-08-19','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(4,'8e94523c-7338-4a54-8fb1-0113be374c0a','WAX_LIQUID',26,1,'2026-09-05','2026-09-05','2026-09-05T21:59:59Z',NULL,NULL,NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(5,'344bafa2-324b-4adc-beb6-d30946602f98','WAX_HOT',26,1,'2026-09-20','2026-09-20','2026-09-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,1,30.0,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(6,'e2cfd7c0-10b6-4b76-ba56-957ab4b2302b','BATTERY_CHARGE',34,1,'2026-09-20','2026-09-20','2026-09-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(7,'cdd7d560-1043-4ab6-915e-d6d10f8d25f6','CHAIN_MEASURE_WEAR',26,1,'2026-09-20','2026-09-20','2026-09-19T22:00:00Z',NULL,NULL,'OK',0.1,'%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(8,'c9ca9e14-64be-410a-bf65-d4927b4a4828','PAD_MEASURE',48,2,'2026-09-30','2026-09-30','2026-09-29T22:00:00Z',NULL,NULL,'OK',1.4,'mm',NULL,NULL,NULL,'gritty winter roads',NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(9,'0d7a39b6-c3ff-4678-9ce4-1652e311ccec','LUBE',43,2,'2026-09-30','2026-09-30','2026-09-29T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(10,'2a229dc7-3957-455f-81f7-0f259811e0cd','FREEHUB_SERVICE',4,1,'2026-08-06','2026-08-06','2026-08-05T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,4500,'done by the seller before the wheel was sold',NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL,NULL);
CREATE TABLE operation (
	id INTEGER NOT NULL, 
	client_op_id VARCHAR(64) NOT NULL, 
	kind VARCHAR(48) NOT NULL, 
	result_json TEXT NOT NULL, 
	created_at VARCHAR(20) NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (client_op_id)
);
CREATE TABLE pick_list_item (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	list_code VARCHAR(24) NOT NULL, 
	name TEXT NOT NULL, 
	hidden_at VARCHAR(20), 
	merged_into_id INTEGER, 
	created_at VARCHAR(20) NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(merged_into_id) REFERENCES pick_list_item (id), 
	UNIQUE (uuid), 
	CONSTRAINT uq_pick_list_item UNIQUE (list_code, name)
);
INSERT INTO "pick_list_item" VALUES(1,'c8bca753-0ed6-436f-9245-5f1a3f833af2','SHOP','Sample shop',NULL,NULL,'2026-11-14T18:52:46Z');
CREATE TABLE product (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	component_type VARCHAR(32) NOT NULL, 
	maker TEXT, 
	model TEXT NOT NULL, 
	specs_json TEXT NOT NULL, 
	spec_source TEXT, 
	spec_version TEXT, 
	notes TEXT, 
	created_at VARCHAR(20) NOT NULL, list_price_cents INTEGER, 
	PRIMARY KEY (id), 
	UNIQUE (uuid)
);
INSERT INTO "product" VALUES(1,'9dbc0a5d-a9a6-42cb-8993-ca643bf7fb73','SHIFTERS','Shimano','ST-R8170','{"function": "Dual control levers, 2\u00d712 Di2, hydraulic disc brake", "connection": "Wireless to the derailleurs", "power": "CR1632 coin cell in each lever", "brake fluid": "Shimano mineral oil"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(2,'3c4f25b4-d5b0-4371-82b2-1b423dd5d173','FRONT_DERAILLEUR','Shimano','FD-R8150','{"speeds": "2\u00d712", "mount": "Braze-on", "max chainring": "52T", "front capacity": "16T", "wire": "EW-SD300"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(3,'f0a6ef1b-c694-47c4-b9da-55f616fb1020','REAR_DERAILLEUR','Shimano','RD-R8150','{"speeds": "12", "max low sprocket": "34T", "total capacity": "39T", "charging": "Charging port for EW-EC300", "wire": "EW-SD300"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(4,'ead9ffcb-2c24-4864-b9c3-632995d6cfe1','PULLEY_WHEEL','Shimano','RD-R8150 guide pulley','{"speeds": "12", "teeth": "13"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(5,'5670dd1b-cb18-4404-bf82-73ccd0640511','PULLEY_WHEEL','Shimano','RD-R8150 tension pulley','{"speeds": "12", "teeth": "13"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(6,'1a5eef34-5891-4840-980a-1f3bf8f49302','CRANKSET','Shimano','FC-R8100 172.5 mm','{"speeds": "2\u00d712", "crank length": "172.5 mm", "chainrings": "52-36T", "spindle": "Hollowtech II, 24 mm", "power meter": "none"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(7,'70a99e40-4a22-496d-9fed-06b0f8e64dda','CHAINRING','Shimano','FC-R8100 chainring 52T','{"teeth": "52", "position": "outer", "for": "FC-R8100 52-36T"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(8,'579500ed-ddd8-426d-a92b-b6ce388dabc3','CHAINRING','Shimano','FC-R8100 chainring 36T','{"teeth": "36", "position": "inner", "for": "FC-R8100 52-36T"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(9,'f2fb569d-e922-4c56-9a87-be0e205013d0','BOTTOM_BRACKET','Shimano','SM-BB-R60','{"standard": "BSA threaded, 68 mm shell", "spindle": "24 mm (Hollowtech II)"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(10,'46e3ee0e-fd2a-4ce5-8a50-db96a69ed908','CASSETTE','Shimano','CS-R8100-12 11-34','{"speeds": "12", "range": "11-34T", "sprockets": "11-12-13-14-15-17-19-21-24-27-30-34", "freehub": "Shimano HG 11-speed road (and 12-speed road) freehub"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(11,'05458023-99ed-488c-a491-593cd3ab6e5a','CHAIN','Shimano','CN-M8100','{"speeds": "12 (Hyperglide+)", "links": "116 (shorten to fit)", "joining": "Quick link SM-CN910-12"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(12,'fff9672b-0190-4156-8f46-fc7670bf8d1c','QUICK_LINK','Shimano','SM-CN910-12','{"speeds": "12", "reuse": "Shimano recommends a new link after opening"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(13,'718893b2-1edb-4f79-9e51-6e494cee08d4','BRAKE_CIRCUIT','Shimano','BR-R8170 front','{"caliper": "BR-R8170, flat mount, 2 pistons", "lever": "ST-R8170", "hose": "SM-BH90-JK-SSR", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(14,'573cfd8d-38c8-4398-b303-ad296a018f9c','BRAKE_CIRCUIT','Shimano','BR-R8170 rear','{"caliper": "BR-R8170, flat mount, 2 pistons", "lever": "ST-R8170", "hose": "SM-BH90-JK-SSR", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(15,'ca7ddea1-671a-48cf-8164-103e2a732a47','BRAKE_PADS','Shimano','L05A-RF','{"compound": "Resin", "cooling": "Fins", "fits": "BR-R8170 (also K05S-RX resin, no fins)"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(16,'d3393c1a-7c32-4831-825c-d757f050c09e','BRAKE_ROTOR','Shimano','RT-CL800 160 mm','{"size": "160 mm", "mount": "Center Lock", "technology": "Ice Tech Freeza", "alternative": "RT-MT800 (same size) is also listed for this caliper"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(17,'159f2651-a674-4388-b74c-f15aee9969d7','BRAKE_ROTOR','Shimano','RT-CL800 140 mm','{"size": "140 mm", "mount": "Center Lock", "technology": "Ice Tech Freeza", "alternative": "RT-MT800 (same size) is also listed for this caliper"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(18,'61593415-1b4d-41c0-9f45-577794727718','BATTERY','Shimano','BT-DN300','{"type": "Internal (seatpost or frame)", "ports": "3 \u00d7 EW-SD300", "charging": "EW-EC300 cable at the rear derailleur port"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(19,'029c1a3f-2388-4760-a859-7852721a592c','SHIFTERS','Shimano','ST-RX820','{"function": "Shift/brake lever right (1\u00d712 mechanical) + brake lever left, hydraulic disc", "brake fluid": "Shimano mineral oil"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(20,'559dc482-ca2c-458b-a83b-8f914440f0b7','REAR_DERAILLEUR','Shimano','RD-RX822-SGS','{"speeds": "12", "max low sprocket": "51T", "clutch": "Shadow RD+"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(21,'5d026abc-6033-4c2e-8ce5-e37bcad9b962','PULLEY_WHEEL','Shimano','RD-RX822 guide pulley','{"speeds": "12", "teeth": "13"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(22,'ec87d1c6-8966-4a20-83e9-91c2d2b8fcba','PULLEY_WHEEL','Shimano','RD-RX822 tension pulley','{"speeds": "12", "teeth": "13"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(23,'8990f0f9-f5ed-4338-aa0b-b1672a0cea50','CRANKSET','Shimano','FC-RX820-1 172.5 mm','{"speeds": "1\u00d712", "crank length": "172.5 mm", "chainring": "40T", "spindle": "Hollowtech II, 24 mm"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(24,'b7b84999-af47-421f-831c-0dff7c243fb0','CHAINRING','Shimano','SM-CRX820-1 40T','{"teeth": "40", "position": "single (1\u00d7)"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(25,'070aff64-7ec3-4447-872d-c6772d1964cb','CASSETTE','Shimano','CS-M8100-12 10-45','{"speeds": "12", "range": "10-45T", "sprockets": "10-12-14-16-18-21-24-28-32-36-40-45", "freehub": "Shimano Micro Spline"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(26,'7e2d0605-d0c6-4eb6-9592-2dc767f692a6','BRAKE_CIRCUIT','Shimano','BR-RX820 front','{"caliper": "BR-RX820, flat mount, 2 pistons", "lever": "ST-RX820", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(27,'4bff5479-d7d8-4e4e-b615-2e179ee83423','BRAKE_CIRCUIT','Shimano','BR-RX820 rear','{"caliper": "BR-RX820, flat mount, 2 pistons", "lever": "ST-RX820", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(28,'14553a56-5425-4d77-a2fe-521f2eaab984','BRAKE_ROTOR','Shimano','RT-MT800 160 mm','{"size": "160 mm", "mount": "Center Lock", "technology": "Ice Tech Freeza"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(29,'94ac062f-fa25-4f0a-9564-657b08a44126','SHIFT_CABLE','Shimano','Shimano shift cable','{"position": "rear"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(30,'0d18dd84-0d9a-4a0c-b65a-16f4d84333bd','SHIFT_HOUSING','Shimano','Shimano shift housing','{"position": "rear"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:46Z',NULL);
INSERT INTO "product" VALUES(31,'0084af83-ee4f-4fe7-ba55-08a957c4fda1','INNER_TUBE','Sample','Road tube 700×28-32','{}',NULL,NULL,NULL,'2026-11-14T18:52:46Z',NULL);
CREATE TABLE product_compatibility (
	id INTEGER NOT NULL, 
	product_id INTEGER NOT NULL, 
	bike_id INTEGER NOT NULL, 
	verified BOOLEAN NOT NULL, 
	note TEXT, 
	created_at VARCHAR(20) NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(bike_id) REFERENCES bike (id), 
	FOREIGN KEY(product_id) REFERENCES product (id), 
	CONSTRAINT uq_product_bike UNIQUE (product_id, bike_id)
);
CREATE TABLE purchase_bundle (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	name TEXT NOT NULL, 
	merchant TEXT, 
	purchased_on VARCHAR(10), 
	price_cents INTEGER, 
	notes TEXT, 
	work_session_id INTEGER, 
	created_at VARCHAR(20) NOT NULL, 
	updated_at VARCHAR(20) NOT NULL, 
	voided_at VARCHAR(20), 
	void_reason TEXT, 
	PRIMARY KEY (id), 
	CONSTRAINT ck_bundle_price CHECK (price_cents IS NULL OR price_cents >= 0), 
	FOREIGN KEY(work_session_id) REFERENCES work_session (id), 
	UNIQUE (uuid)
);
INSERT INTO "purchase_bundle" VALUES(1,'d5650ca1-aff1-404c-a2e5-45cf3e8f3109','Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','Sample shop','2026-08-11',165000,NULL,1,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL);
CREATE TABLE "reminder_snooze" (
	id INTEGER NOT NULL, 
	component_id INTEGER, 
	rule_code VARCHAR(48) NOT NULL, 
	until_date VARCHAR(10), 
	until_km FLOAT, 
	note TEXT, 
	created_at VARCHAR(20) NOT NULL, 
	cleared_at VARCHAR(20), 
	bike_id INTEGER, 
	PRIMARY KEY (id), 
	CONSTRAINT fk_reminder_snooze_bike FOREIGN KEY(bike_id) REFERENCES bike (id), 
	FOREIGN KEY(component_id) REFERENCES component (id)
);
CREATE TABLE ride (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	bike_id INTEGER, 
	name TEXT, 
	ride_date VARCHAR(10) NOT NULL, 
	start_time_utc VARCHAR(20), 
	sort_utc VARCHAR(20) NOT NULL, 
	distance_km FLOAT, 
	duration_s INTEGER, 
	sport_type VARCHAR(32) NOT NULL, 
	usage_profile_id INTEGER, 
	source_kind VARCHAR(16) NOT NULL, 
	status VARCHAR(16) NOT NULL, 
	inclusion VARCHAR(16) NOT NULL, 
	exclusion_reason TEXT, 
	assignment_uncertain BOOLEAN NOT NULL, 
	uncertainty_note TEXT, 
	notes TEXT, 
	created_at VARCHAR(20) NOT NULL, 
	updated_at VARCHAR(20) NOT NULL, conditions VARCHAR(8), 
	PRIMARY KEY (id), 
	CONSTRAINT ck_ride_inclusion CHECK (inclusion IN ('INCLUDED','EXCLUDED')), 
	CONSTRAINT ck_ride_source_kind CHECK (source_kind IN ('MANUAL','CSV','STRAVA')), 
	CONSTRAINT ck_ride_status CHECK (status IN ('ACTIVE','SOURCE_DELETED')), 
	CONSTRAINT ck_ride_distance CHECK (distance_km IS NULL OR distance_km >= 0), 
	FOREIGN KEY(bike_id) REFERENCES bike (id), 
	FOREIGN KEY(usage_profile_id) REFERENCES usage_profile (id), 
	UNIQUE (uuid)
);
INSERT INTO "ride" VALUES(1,'66105b46-92dd-484f-9c24-e53201cf74f4',1,'Coffee ride','2026-08-22',NULL,'2026-08-21T22:00:00Z',78.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(2,'e9a4607f-8105-4ef2-b628-b280df5017e4',1,'Vineyards','2026-08-25',NULL,'2026-08-24T22:00:00Z',83.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(3,'9511f120-c1d0-4926-9269-d599751cf6d8',1,'Coffee ride','2026-08-27',NULL,'2026-08-26T22:00:00Z',87.2,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(4,'4750a4cc-19c0-4170-a5a1-5b56d9a93ca9',1,'Zwift workout','2026-08-29','2026-08-29T16:30:00Z','2026-08-29T16:30:00Z',38.4,3600,'VirtualRide',2,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL);
INSERT INTO "ride" VALUES(5,'08492a10-340d-4b44-bf59-342ef8dd571e',2,'Long Sunday','2026-08-30',NULL,'2026-08-29T22:00:00Z',55.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','WET');
INSERT INTO "ride" VALUES(6,'5e6d9f1d-25fc-4da1-9f3d-b29b98e27934',1,'Coffee ride','2026-09-05',NULL,'2026-09-04T22:00:00Z',78.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(7,'84d50957-9161-4d6f-add2-326a45c3acb8',2,'Club ride','2026-09-06',NULL,'2026-09-05T22:00:00Z',66.9,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','WET');
INSERT INTO "ride" VALUES(8,'d5c75adc-d09e-454f-84a8-3a62cc69b8bf',1,'After work','2026-09-10',NULL,'2026-09-09T22:00:00Z',37.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(9,'ea538874-8473-4652-a83b-6ef65217ca6c',1,'Vineyards','2026-09-12',NULL,'2026-09-11T22:00:00Z',84.8,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(10,'bda677df-9922-4bfd-843e-445727100e20',2,'Recovery spin','2026-09-13',NULL,'2026-09-12T22:00:00Z',80.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(11,'4806de72-ab72-4ba8-bc2a-3856ab110d15',1,'Recovery spin','2026-09-15',NULL,'2026-09-14T22:00:00Z',106.8,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(12,'aa2c002b-cd04-4402-9323-a12094ff097e',1,'Hill repeats','2026-09-17',NULL,'2026-09-16T22:00:00Z',37.2,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(13,'e3983144-16f2-4cbf-b70a-b032c9733470',1,'Coffee ride','2026-09-19',NULL,'2026-09-18T22:00:00Z',79.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(14,'e074d987-60c2-4c56-bfa5-8f73114f7c7e',2,'Hill repeats','2026-09-20',NULL,'2026-09-19T22:00:00Z',47.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(15,'33f46ed1-1660-4d05-bf60-713e0c9b79c4',1,'Gravel detour','2026-09-22',NULL,'2026-09-21T22:00:00Z',92.3,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(16,'8a77a2f9-ae7a-4bf3-bdf6-3e927b013cdf',1,'Gravel detour','2026-09-24',NULL,'2026-09-23T22:00:00Z',81.6,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(17,'3fe8f408-bf47-44e4-9f90-99bbee6e5eb7',1,'Club ride','2026-09-26',NULL,'2026-09-25T22:00:00Z',52.2,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','WET');
INSERT INTO "ride" VALUES(18,'c9efc5a5-9f5b-49d6-90ed-c881e0da5313',2,'Vineyards','2026-09-27',NULL,'2026-09-26T22:00:00Z',84.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(19,'c7953bc8-6ad8-4108-87c8-5195cd4a4e65',1,'Zwift workout','2026-10-01','2026-10-01T16:30:00Z','2026-10-01T16:30:00Z',35.4,3600,'VirtualRide',2,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL);
INSERT INTO "ride" VALUES(20,'52845280-916e-4b70-b474-3ac64cda8d68',1,'Long Sunday','2026-10-03',NULL,'2026-10-02T22:00:00Z',77.3,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(21,'75f53105-0b87-4e3c-9c80-c2e9b174424c',1,'Coffee ride','2026-10-06',NULL,'2026-10-05T22:00:00Z',112.9,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(22,'b360b9db-90b4-4d0a-8d7b-5b9497e87b59',1,'River path','2026-10-08',NULL,'2026-10-07T22:00:00Z',57.0,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(23,'b6c90647-fe95-4ac8-a344-eb1c62f057b4',1,'Club ride','2026-10-10',NULL,'2026-10-09T22:00:00Z',40.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(24,'7f712de0-b162-4981-8f2d-e457ac27cf0f',2,'Long Sunday','2026-10-11',NULL,'2026-10-10T22:00:00Z',49.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','WET');
INSERT INTO "ride" VALUES(25,'483c0277-d14a-45a2-9851-eb5ac4e9e737',1,'Coffee ride','2026-10-15',NULL,'2026-10-14T22:00:00Z',81.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','DRY');
INSERT INTO "ride" VALUES(26,'f56dc5f6-8f55-4523-b0a7-497ff8124dfe',1,'Zwift workout','2026-10-17','2026-10-17T16:30:00Z','2026-10-17T16:30:00Z',25.7,3600,'VirtualRide',2,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL);
INSERT INTO "ride" VALUES(27,'b4291357-656a-4ccd-84f5-577dc458c8e8',2,'After work','2026-10-18',NULL,'2026-10-17T22:00:00Z',53.4,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','WET');
CREATE TABLE ride_equipment (
	ride_id INTEGER NOT NULL, 
	slot VARCHAR(32) NOT NULL, 
	component_id INTEGER, 
	note TEXT, 
	PRIMARY KEY (ride_id, slot), 
	FOREIGN KEY(component_id) REFERENCES component (id), 
	FOREIGN KEY(ride_id) REFERENCES ride (id)
);
CREATE TABLE ride_flag (
	id INTEGER NOT NULL, 
	ride_id INTEGER NOT NULL, 
	code VARCHAR(32) NOT NULL, 
	slot VARCHAR(32), 
	detail TEXT NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(ride_id) REFERENCES ride (id)
);
CREATE TABLE ride_override (
	ride_id INTEGER NOT NULL, 
	field VARCHAR(32) NOT NULL, 
	value_json TEXT NOT NULL, 
	set_at VARCHAR(20) NOT NULL, 
	PRIMARY KEY (ride_id, field), 
	FOREIGN KEY(ride_id) REFERENCES ride (id)
);
CREATE TABLE ride_source (
	id INTEGER NOT NULL, 
	ride_id INTEGER NOT NULL, 
	source_kind VARCHAR(16) NOT NULL, 
	source_account VARCHAR(64) NOT NULL, 
	source_ref VARCHAR(128) NOT NULL, 
	values_json TEXT NOT NULL, 
	payload_hash VARCHAR(64) NOT NULL, 
	import_batch_id INTEGER, 
	first_seen_at VARCHAR(20) NOT NULL, 
	last_seen_at VARCHAR(20) NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(import_batch_id) REFERENCES import_batch (id), 
	FOREIGN KEY(ride_id) REFERENCES ride (id), 
	UNIQUE (ride_id), 
	CONSTRAINT uq_ride_source_identity UNIQUE (source_kind, source_account, source_ref)
);
CREATE TABLE service_order (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	component_id INTEGER NOT NULL, 
	bike_id INTEGER, 
	from_bike_id INTEGER, 
	from_parent_id INTEGER, 
	from_slot VARCHAR(40), 
	sent_at VARCHAR(20) NOT NULL, 
	sent_on VARCHAR(10) NOT NULL, 
	shop TEXT, 
	reason TEXT, 
	incident_group VARCHAR(36), 
	send_session_id INTEGER, 
	status VARCHAR(8) NOT NULL, 
	returned_at VARCHAR(20), 
	returned_on VARCHAR(10), 
	outcome VARCHAR(20), 
	cost_cents INTEGER, 
	receipt_ref TEXT, 
	return_notes TEXT, 
	return_session_id INTEGER, 
	event_id INTEGER, 
	replacement_id INTEGER, 
	created_at VARCHAR(20) NOT NULL, 
	PRIMARY KEY (id), 
	CONSTRAINT ck_service_order_status CHECK (status IN ('OUT','BACK','VOIDED')), 
	CONSTRAINT ck_service_order_cost CHECK (cost_cents IS NULL OR cost_cents >= 0), 
	FOREIGN KEY(bike_id) REFERENCES bike (id), 
	FOREIGN KEY(component_id) REFERENCES component (id), 
	FOREIGN KEY(event_id) REFERENCES maintenance_event (id), 
	FOREIGN KEY(from_bike_id) REFERENCES bike (id), 
	FOREIGN KEY(from_parent_id) REFERENCES component (id), 
	FOREIGN KEY(replacement_id) REFERENCES component (id), 
	FOREIGN KEY(return_session_id) REFERENCES work_session (id), 
	FOREIGN KEY(send_session_id) REFERENCES work_session (id), 
	UNIQUE (uuid)
);
CREATE TABLE "service_rule" (
        id INTEGER NOT NULL, uuid VARCHAR(36) NOT NULL, rule_code VARCHAR(48) NOT NULL, name TEXT NOT NULL,
        component_type VARCHAR(32), component_id INTEGER, bike_id INTEGER, action_code VARCHAR(32) NOT NULL,
        "trigger" VARCHAR(20) NOT NULL, interval_km FLOAT, interval_months INTEGER,
        window_min_km FLOAT, window_max_km FLOAT, cycle_action_code VARCHAR(32), reset_actions_json TEXT NOT NULL,
        warn_km FLOAT, warn_days INTEGER, origin VARCHAR(16) NOT NULL, active BOOLEAN NOT NULL, notes TEXT,
        created_at VARCHAR(20) NOT NULL, updated_at VARCHAR(20) NOT NULL, requires_setup VARCHAR(12),
        interval_hours FLOAT, warn_hours FLOAT, interval_count INTEGER, after_top_up_km FLOAT,
        PRIMARY KEY (id),
        CONSTRAINT ck_rule_origin CHECK (origin IN ('DEFAULT','MANUFACTURER','PERSONAL')),
        CONSTRAINT ck_rule_window CHECK (trigger <> 'CYCLE_WINDOW' OR (window_min_km IS NOT NULL AND
            window_max_km >= window_min_km AND cycle_action_code IS NOT NULL)),
        CONSTRAINT ck_rule_interval CHECK (trigger <> 'INTERVAL' OR interval_km IS NOT NULL OR
            interval_months IS NOT NULL OR interval_hours IS NOT NULL),
        CONSTRAINT ck_rule_trigger CHECK (trigger IN ('INTERVAL','CYCLE_WINDOW','PARENT_COUNT','ONCE_AFTER_INSTALL')),
        CONSTRAINT ck_rule_count CHECK (trigger <> 'PARENT_COUNT' OR interval_count >= 1),
        CONSTRAINT ck_rule_target CHECK ((component_type IS NOT NULL) + (component_id IS NOT NULL) + (bike_id IS NOT NULL) = 1),
        FOREIGN KEY(component_id) REFERENCES component (id),
        FOREIGN KEY(bike_id) REFERENCES bike (id),
        UNIQUE (uuid)
    );
INSERT INTO "service_rule" VALUES(1,'43843c3d-7d9e-42ff-ae44-c5680267b3de','CHAIN_HOT_WAX','Hot wax chain','CHAIN',NULL,NULL,'WAX_HOT','INTERVAL',500.0,NULL,NULL,NULL,NULL,'["WAX_HOT"]',50.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,200.0);
INSERT INTO "service_rule" VALUES(2,'c3205c4a-7d87-4006-bfb0-d659f024ddf0','CHAIN_LIQUID_WAX','Liquid-wax top-up','CHAIN',NULL,NULL,'WAX_LIQUID','CYCLE_WINDOW',NULL,NULL,250.0,300.0,'WAX_HOT','["WAX_LIQUID"]',25.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(3,'0c1f27de-ffac-4eed-b671-b807d6f3c034','CHAIN_WEAR_CHECK','Measure chain wear','CHAIN',NULL,NULL,'CHAIN_MEASURE_WEAR','INTERVAL',1000.0,NULL,NULL,NULL,NULL,'["CHAIN_MEASURE_WEAR"]',100.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(4,'53bc62ac-e3e8-4e1d-b2b0-bfcf327267a9','BRAKE_FLUID','Replace brake fluid','BRAKE_CIRCUIT',NULL,NULL,'BRAKE_FLUID_REPLACE','INTERVAL',NULL,24,NULL,NULL,NULL,'["BRAKE_FLUID_REPLACE"]',NULL,30,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(5,'28e93e59-8270-4e69-bcca-c6f0bd696445','BRAKE_PAD_CHECK','Check brake pads','BRAKE_PADS',NULL,NULL,'PAD_MEASURE','INTERVAL',1000.0,NULL,NULL,NULL,NULL,'["PAD_MEASURE"]',100.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(6,'9901361d-eecc-46d8-b540-b10f269d0264','FRONT_WHEEL_INSPECTION','Inspect wheel','FRONT_WHEEL',NULL,NULL,'WHEEL_INSPECT','INTERVAL',3000.0,12,NULL,NULL,NULL,'["WHEEL_INSPECT"]',200.0,30,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(7,'fb496c62-5093-48c4-b274-1ad8e63d08de','REAR_WHEEL_INSPECTION','Inspect wheel','REAR_WHEEL',NULL,NULL,'WHEEL_INSPECT','INTERVAL',3000.0,12,NULL,NULL,NULL,'["WHEEL_INSPECT"]',200.0,30,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(8,'faf762c6-537e-4bc4-b8ef-225261e14a67','FRONT_HUB_BEARINGS','Service hub bearings','FRONT_WHEEL',NULL,NULL,'HUB_BEARING_SERVICE','INTERVAL',10000.0,NULL,NULL,NULL,NULL,'["HUB_BEARING_SERVICE"]',500.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(9,'e2c95225-4431-46b1-bdad-6503efac0af5','REAR_HUB_BEARINGS','Service hub bearings','REAR_WHEEL',NULL,NULL,'HUB_BEARING_SERVICE','INTERVAL',10000.0,NULL,NULL,NULL,NULL,'["HUB_BEARING_SERVICE"]',500.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(10,'debdb723-9114-401d-a4cd-1b3ac595c5a2','FREEHUB','Service freehub','REAR_WHEEL',NULL,NULL,'FREEHUB_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["FREEHUB_SERVICE"]',300.0,30,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(11,'d35d4eb4-c678-49b0-877f-1ec4e29d9400','TIRE_CHECK','Inspect tire','TIRE',NULL,NULL,'TIRE_INSPECT','INTERVAL',1000.0,12,NULL,NULL,NULL,'["TIRE_INSPECT"]',100.0,30,'DEFAULT',1,'Yearly also for sidewall cracks from age; no bicycle-tire age limit was found.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(12,'123ba214-ee9c-4981-bd7d-e333bdbebef5','TIRE_SEALANT','Top up sealant','TIRE',NULL,NULL,'SEALANT_TOP_UP','INTERVAL',NULL,3,NULL,NULL,NULL,'["SEALANT_TOP_UP", "SEALANT_RENEW"]',NULL,14,'MANUFACTURER',1,'Stan''s: sealant lasts 2–6 months; check every 3 months (stans.com sealant support).','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','TUBELESS',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(13,'2475d0c3-b690-40b8-bb29-5c867e023d8b','TIRE_SEALANT_RENEW','Clean out and renew sealant','TIRE',NULL,NULL,'SEALANT_RENEW','INTERVAL',NULL,12,NULL,NULL,NULL,'["SEALANT_RENEW"]',NULL,30,'MANUFACTURER',1,'Stan''s: take the tire off and clean out old sealant once a year; check rim tape and valves at the same time (stans.com sealant support).','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','TUBELESS',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(14,'183fda97-fcbd-4bc2-8ce8-e31347fc671a','VALVE_CORE','Replace valve core','TUBELESS_VALVE',NULL,NULL,'VALVE_CORE_REPLACE','INTERVAL',NULL,12,NULL,NULL,NULL,'["VALVE_CORE_REPLACE"]',NULL,30,'DEFAULT',1,'At the yearly sealant clean-out; personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','TUBELESS',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(15,'bb3e8273-8c83-4d84-b561-0dfa1d54f285','FRONT_THRU_AXLE','Check and grease thru-axle','FRONT_WHEEL',NULL,NULL,'THRU_AXLE_SERVICE','INTERVAL',NULL,6,NULL,NULL,NULL,'["THRU_AXLE_SERVICE"]',NULL,14,'DEFAULT',1,'Personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(16,'95559f5d-96dc-436c-8667-aa9a5c6318dc','REAR_THRU_AXLE','Check and grease thru-axle','REAR_WHEEL',NULL,NULL,'THRU_AXLE_SERVICE','INTERVAL',NULL,6,NULL,NULL,NULL,'["THRU_AXLE_SERVICE"]',NULL,14,'DEFAULT',1,'Personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(17,'40708451-999c-4d3c-a71f-1917f8f9bd68','HEADSET_SERVICE','Service headset','HEADSET',NULL,NULL,'HEADSET_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["HEADSET_SERVICE"]',300.0,30,'DEFAULT',1,NULL,'2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(18,'ccb1c276-ff63-4d8b-a415-e8c3b160fcdb','DI2_BATTERY_CHARGE','Charge Di2 battery','BATTERY',NULL,NULL,'BATTERY_CHARGE','INTERVAL',800.0,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',100.0,NULL,'DEFAULT',1,'Shimano BT-DN300: about 1000 km per charge (less with much front shifting); 800 km leaves a margin. Source: retailer listings (Rose, Tweeks), not verified with Shimano.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(19,'3809dcaa-c36d-46ee-998d-8e15578f9c74','POWER_METER_CHARGE','Charge power meter','POWER_METER',NULL,NULL,'POWER_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["POWER_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your power meter''s battery life with a margin.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,50.0,10.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(20,'55a0a9e9-55dd-4f99-b17c-ac24ea09b495','POWER_PEDALS_CHARGE','Charge power-meter pedals','POWER_METER_PEDALS',NULL,NULL,'POWER_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["POWER_CHARGE"]',NULL,NULL,'DEFAULT',1,'Favero Assioma PRO RS-1: at least 60 h per charge (up to about 160 h after a firmware update). 80 h is your choice (2026-10-26). Source: retailer listings quoting Favero, not verified.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,80.0,10.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(21,'769b888a-f50e-49fc-af53-ea97222e619a','SENSOR_BATTERY','Replace sensor battery','SENSOR',NULL,NULL,'COIN_CELL_REPLACE','INTERVAL',NULL,12,NULL,NULL,NULL,'["COIN_CELL_REPLACE"]',NULL,30,'DEFAULT',1,'Magene S3+ (CR2032): about 500 h of riding per battery (retailer listings, not verified with Magene); 400 h leaves a margin. 12 months covers standby drain (your estimate).','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,400.0,40.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(22,'903cd443-0f08-4a9f-9667-58d6091a9645','SHIFTER_COIN_CELLS','Replace shifter coin cells','SHIFTERS',NULL,NULL,'COIN_CELL_REPLACE','INTERVAL',NULL,18,NULL,NULL,NULL,'["COIN_CELL_REPLACE"]',NULL,30,'DEFAULT',0,'Wireless Di2 levers (CR1632): about 1.5–2 years (retailer listings); 18 months leaves a margin. Off by default (wired and mechanical levers have no coin cell); switch it on for wireless levers. Keep CR1632 cells as counted stock to pick them when logging.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(23,'16dc6669-3837-46f6-aaba-61b00a615977','COMPUTER_CHARGE','Charge bike computer','BIKE_COMPUTER',NULL,NULL,'BATTERY_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your device''s battery life with a margin (personal value).','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,20.0,4.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(24,'0c3c0ae9-27ee-49c8-8bc9-5306a247af19','LIGHT_CHARGE','Charge light','LIGHT',NULL,NULL,'BATTERY_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your light''s run time in the mode you use (personal value).','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,4.0,1.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(25,'2e9a2b03-cb06-4067-866c-fe2b219bf8d6','RADAR_CHARGE','Charge radar','RADAR',NULL,NULL,'BATTERY_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your radar''s run time in the mode you use (personal value).','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,6.0,2.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(26,'3bcff08d-c897-4be2-86a7-0e3bbe043d92','PULLEY_CHECK','Check pulley wheels','PULLEY_WHEEL',NULL,NULL,'PULLEY_INSPECT','INTERVAL',5000.0,NULL,NULL,NULL,NULL,'["PULLEY_INSPECT"]',300.0,NULL,'DEFAULT',1,'Common workshop practice, not a maker''s figure.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(27,'c70a2332-0475-42a1-b7eb-d7c654a21947','CHAINRING_CHECK','Check chainring wear','CHAINRING',NULL,NULL,'CHAINRING_INSPECT','INTERVAL',5000.0,NULL,NULL,NULL,NULL,'["CHAINRING_INSPECT"]',300.0,NULL,'DEFAULT',1,'Check at least at every chain change; common practice, not a maker''s figure.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(28,'d7ff40d3-c9b3-42c2-a337-796593f4ccf0','QUICK_LINK_CHAINS','Replace quick link','QUICK_LINK',NULL,NULL,'QUICK_LINK_CHECK','PARENT_COUNT',NULL,NULL,NULL,NULL,NULL,'["QUICK_LINK_CHECK"]',NULL,NULL,'DEFAULT',1,'Wippermann Connex links are sold as reusable many times; no official limit was found. Replace after 2 chains (your choice) or as soon as it closes noticeably looser than new.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,2,NULL);
INSERT INTO "service_rule" VALUES(29,'9f59abf5-dcdd-42f3-9873-58636d3cc78f','RIM_TAPE_CHECK','Check rim tape','RIM_TAPE',NULL,NULL,'RIM_TAPE_CHECK','INTERVAL',NULL,12,NULL,NULL,NULL,'["RIM_TAPE_CHECK"]',NULL,30,'DEFAULT',1,'Check at every tire change or yearly (tubes: tape covers the spoke holes; tubeless: it seals).','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(30,'a1f07d6a-9d32-4a67-8fe9-e509fa454c6e','HOSE_CHECK','Inspect brake hoses and caliper','BRAKE_CIRCUIT',NULL,NULL,'HOSE_INSPECT','INTERVAL',NULL,12,NULL,NULL,NULL,'["HOSE_INSPECT", "BRAKE_FLUID_REPLACE"]',NULL,30,'DEFAULT',1,'With every fluid change or yearly; personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(31,'0142883a-7d03-4fca-b815-585c27d53515','PAD_BED_IN','Bed in new pads','BRAKE_PADS',NULL,NULL,'BED_IN','ONCE_AFTER_INSTALL',NULL,NULL,NULL,100.0,NULL,'["BED_IN"]',NULL,NULL,'DEFAULT',1,'Once after fitting; after 100 km without it the pads count as bedded in.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(32,'ed51919f-2dce-465a-985e-c954b566d5bf','ROTOR_BED_IN','Bed in new rotor','BRAKE_ROTOR',NULL,NULL,'BED_IN','ONCE_AFTER_INSTALL',NULL,NULL,NULL,100.0,NULL,'["BED_IN"]',NULL,NULL,'DEFAULT',1,'Once after fitting; after 100 km without it the rotor counts as bedded in.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(33,'143fce5a-e7db-4d3f-8c70-358b7ffcd3ec','PEDAL_BEARINGS','Service pedal bearings','PEDALS',NULL,NULL,'PEDAL_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["PEDAL_SERVICE"]',300.0,30,'DEFAULT',1,'Rider figure, not a maker''s interval.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(34,'b9a0c26c-c510-48b0-acb4-45ef1f0e5051','POWER_PEDAL_BEARINGS','Service pedal bearings','POWER_METER_PEDALS',NULL,NULL,'PEDAL_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["PEDAL_SERVICE"]',300.0,30,'DEFAULT',1,'No Favero interval found; riders regrease Assioma pedals about yearly or every 2,500 km.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(35,'fcc1ebe4-bbbf-4853-ae57-ca506904a2ba','BB_CHECK','Check bottom bracket','BOTTOM_BRACKET',NULL,NULL,'BB_INSPECT','INTERVAL',6000.0,12,NULL,NULL,NULL,'["BB_INSPECT"]',300.0,30,'DEFAULT',1,'Personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(36,'d9ce1002-dc6f-4031-93b7-e2c2ca0beaab','BAR_TAPE_CHECK','Inspect bar tape','BAR_TAPE',NULL,NULL,'BAR_TAPE_INSPECT','INTERVAL',NULL,12,NULL,NULL,NULL,'["BAR_TAPE_INSPECT", "BAR_TAPE_REWRAP"]',NULL,30,'DEFAULT',1,'Personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(37,'6ca5cc0a-4526-46c4-9584-c0e459d0ecd7','SEATPOST_PASTE','Re-paste seatpost','SEATPOST',NULL,NULL,'SEATPOST_SERVICE','INTERVAL',NULL,12,NULL,NULL,NULL,'["SEATPOST_SERVICE"]',NULL,30,'DEFAULT',1,'Stops a seatpost from seizing; personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(38,'9201fb98-8f03-426f-bdc6-59ad1e7e0823','HANGER_CHECK','Check derailleur hanger','DERAILLEUR_HANGER',NULL,NULL,'HANGER_ALIGN','INTERVAL',NULL,12,NULL,NULL,NULL,'["HANGER_ALIGN"]',NULL,30,'DEFAULT',1,'Also after every crash; personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(39,'73614740-3d31-416f-a706-fd115c3bd64f','CLEAT_CHECK','Inspect cleats','CLEATS',NULL,NULL,'CLEAT_INSPECT','INTERVAL',2000.0,NULL,NULL,NULL,NULL,'["CLEAT_INSPECT"]',200.0,NULL,'DEFAULT',1,'Replace when a wear pad is worn through or clipping feels different, often about 6,000 km (rider figure; BikeRadar).','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(40,'03e9f28a-5f3e-45ec-99ad-545aa4b4ec9f','SHIFT_CABLE_CHECK','Check shift cable','SHIFT_CABLE',NULL,NULL,'CABLE_INSPECT','INTERVAL',5000.0,12,NULL,NULL,NULL,'["CABLE_INSPECT"]',300.0,30,'DEFAULT',1,'Personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','MECHANICAL',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(41,'cc7683b5-8e8d-496f-a102-c362300b7bd7','SHIFT_HOUSING_CHECK','Check shift housing','SHIFT_HOUSING',NULL,NULL,'CABLE_INSPECT','INTERVAL',5000.0,12,NULL,NULL,NULL,'["CABLE_INSPECT"]',300.0,30,'DEFAULT',1,'Personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','MECHANICAL',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(42,'e158d240-b076-4852-a827-f07f4be2dff5','BIKE_TORQUE_CHECK','Torque check','BIKE',NULL,NULL,'TORQUE_CHECK','INTERVAL',NULL,3,NULL,NULL,NULL,'["TORQUE_CHECK"]',NULL,14,'DEFAULT',1,'Every 3 months and once after the first ride on a newly fitted part (personal value). Torque values come from each product''s spec (torque_nm) where you entered it.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(43,'dbb79fb6-7e93-4333-9b33-d5fc68f68746','BIKE_DI2_CHECK','Di2 check (firmware, errors)','BIKE',NULL,NULL,'DI2_SYSTEM_CHECK','INTERVAL',NULL,6,NULL,NULL,NULL,'["DI2_SYSTEM_CHECK"]',NULL,14,'DEFAULT',1,'Firmware is updated with Shimano E-TUBE; 6 months is a personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','ELECTRONIC',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(44,'3941c1a0-a344-4f02-aebd-4ced061a4d1c','BIKE_DI2_WIRES','Inspect Di2 wires','BIKE',NULL,NULL,'DI2_WIRE_INSPECT','INTERVAL',NULL,12,NULL,NULL,NULL,'["DI2_WIRE_INSPECT"]',NULL,30,'DEFAULT',1,'Personal value.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z','ELECTRONIC',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(45,'c0ba7307-f582-4c78-82da-ffea0aa84638','BIKE_FULL_SERVICE','Yearly full service','BIKE',NULL,NULL,'FULL_SERVICE','INTERVAL',NULL,12,NULL,NULL,NULL,'["FULL_SERVICE"]',NULL,30,'DEFAULT',1,'Once a year, a full service of the whole bike: Wheel hub bearings: play and roughness; Headset: clean, grease, check play; Bottom bracket: play and noise; Brakes: bleed (or check lever feel), hoses, pads, rotors; Di2 wires and junction / shift cables and housing; Frame and fork: cracks, dents, chips; Drivetrain: deep clean, chain, cassette and chainring wear; Pedals: bearing play; Torque check of all bolts. Personal value; each job keeps its own reminder.','2026-11-14T18:52:46Z','2026-11-14T18:52:46Z',NULL,NULL,NULL,NULL,NULL);
CREATE TABLE strava_connection (
	athlete_id VARCHAR(32) NOT NULL, 
	status VARCHAR(16) NOT NULL, 
	retention_mode VARCHAR(16) NOT NULL, 
	cursor_epoch INTEGER, 
	last_success_at VARCHAR(20), 
	last_error TEXT, 
	updated_at VARCHAR(20) NOT NULL, 
	PRIMARY KEY (athlete_id), 
	CONSTRAINT ck_strava_retention CHECK (retention_mode IN ('PERMANENT','PROVISIONAL')), 
	CONSTRAINT ck_strava_status CHECK (status IN ('NOT_CONNECTED','ACTIVE','PAUSED','DISCONNECTED'))
);
CREATE TABLE usage_adjustment (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	component_id INTEGER, 
	bike_id INTEGER, 
	kind VARCHAR(16) NOT NULL, 
	effective_at VARCHAR(20) NOT NULL, 
	effective_utc VARCHAR(20) NOT NULL, 
	km FLOAT NOT NULL, 
	is_estimate BOOLEAN NOT NULL, 
	note TEXT, 
	voided_at VARCHAR(20), 
	created_at VARCHAR(20) NOT NULL, 
	PRIMARY KEY (id), 
	CONSTRAINT ck_adjustment_kind CHECK (kind IN ('STARTING','CORRECTION')), 
	CONSTRAINT ck_adjustment_target CHECK ((bike_id IS NULL) <> (component_id IS NULL)), 
	FOREIGN KEY(bike_id) REFERENCES bike (id), 
	FOREIGN KEY(component_id) REFERENCES component (id), 
	UNIQUE (uuid)
);
INSERT INTO "usage_adjustment" VALUES(1,'a0ddb2c0-2068-4ee3-a0d6-e0bd8bd271fa',NULL,1,'STARTING','2026-08-19','2026-08-18T22:00:00Z',850.0,1,NULL,NULL,'2026-11-14T18:52:46Z');
INSERT INTO "usage_adjustment" VALUES(2,'02c2c985-1901-466c-9ca3-0708630a4ac5',1,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',850.0,1,'from Aurora SL''s starting km',NULL,'2026-11-14T18:52:46Z');
INSERT INTO "usage_adjustment" VALUES(3,'961bd7ae-a046-452a-91ba-600958c1d3e6',NULL,2,'STARTING','2026-08-19','2026-08-18T22:00:00Z',4200.0,1,NULL,NULL,'2026-11-14T18:52:46Z');
INSERT INTO "usage_adjustment" VALUES(4,'73e8dc9b-1b1c-49dc-94f5-ed58049c8b18',2,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',4200.0,1,'from Winter Allroad''s starting km',NULL,'2026-11-14T18:52:46Z');
INSERT INTO "usage_adjustment" VALUES(5,'9233a9b7-c979-49c1-a2f0-7d81032e400b',4,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',1200.0,1,'bought used; seller''s estimate',NULL,'2026-11-14T18:52:46Z');
CREATE TABLE usage_contribution (
	ride_id INTEGER NOT NULL, 
	component_id INTEGER NOT NULL, 
	bike_id INTEGER NOT NULL, 
	slot VARCHAR(32) NOT NULL, 
	sort_utc VARCHAR(20) NOT NULL, 
	km FLOAT NOT NULL, 
	duration_s INTEGER, 
	basis VARCHAR(16) NOT NULL, 
	certain BOOLEAN NOT NULL, 
	state VARCHAR(16) NOT NULL, 
	note TEXT, 
	PRIMARY KEY (ride_id, component_id), 
	CONSTRAINT ck_contribution_basis CHECK (basis IN ('HISTORY','EXPLICIT')), 
	CONSTRAINT ck_contribution_state CHECK (state IN ('COUNTED','IN_BASELINE')), 
	FOREIGN KEY(bike_id) REFERENCES bike (id), 
	FOREIGN KEY(component_id) REFERENCES component (id), 
	FOREIGN KEY(ride_id) REFERENCES ride (id)
);
INSERT INTO "usage_contribution" VALUES(1,1,1,'FRAME','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,15,1,'WHEELSET','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,3,1,'FRONT_WHEEL','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,5,1,'TIRE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,6,1,'TUBE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,32,1,'ROTOR','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,4,1,'REAR_WHEEL','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,7,1,'TIRE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,8,1,'TUBE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,25,1,'CASSETTE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,33,1,'ROTOR','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,16,1,'SHIFTERS','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,17,1,'FRONT_DERAILLEUR','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,18,1,'REAR_DERAILLEUR','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,19,1,'PULLEY_UPPER','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,20,1,'PULLEY_LOWER','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,21,1,'CRANKSET','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,22,1,'CHAINRING_OUTER','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,23,1,'CHAINRING_INNER','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,24,1,'BOTTOM_BRACKET','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,26,1,'CHAIN','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,27,1,'QUICK_LINK','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,28,1,'FRONT_BRAKE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,29,1,'REAR_BRAKE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,30,1,'FRONT_PADS','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,31,1,'REAR_PADS','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,34,1,'BATTERY','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,1,1,'FRAME','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,15,1,'WHEELSET','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,3,1,'FRONT_WHEEL','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,5,1,'TIRE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,6,1,'TUBE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,32,1,'ROTOR','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,4,1,'REAR_WHEEL','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,7,1,'TIRE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,25,1,'CASSETTE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,33,1,'ROTOR','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,53,1,'TUBE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,16,1,'SHIFTERS','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,17,1,'FRONT_DERAILLEUR','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,18,1,'REAR_DERAILLEUR','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,19,1,'PULLEY_UPPER','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,20,1,'PULLEY_LOWER','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,21,1,'CRANKSET','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,22,1,'CHAINRING_OUTER','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,23,1,'CHAINRING_INNER','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,24,1,'BOTTOM_BRACKET','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,26,1,'CHAIN','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,27,1,'QUICK_LINK','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,28,1,'FRONT_BRAKE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,29,1,'REAR_BRAKE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,30,1,'FRONT_PADS','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,31,1,'REAR_PADS','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,34,1,'BATTERY','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,1,1,'FRAME','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,15,1,'WHEELSET','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,3,1,'FRONT_WHEEL','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,5,1,'TIRE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,6,1,'TUBE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,32,1,'ROTOR','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,4,1,'REAR_WHEEL','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,7,1,'TIRE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,25,1,'CASSETTE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,33,1,'ROTOR','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,53,1,'TUBE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,16,1,'SHIFTERS','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,17,1,'FRONT_DERAILLEUR','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,18,1,'REAR_DERAILLEUR','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,19,1,'PULLEY_UPPER','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,20,1,'PULLEY_LOWER','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,21,1,'CRANKSET','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,22,1,'CHAINRING_OUTER','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,23,1,'CHAINRING_INNER','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,24,1,'BOTTOM_BRACKET','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,26,1,'CHAIN','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,27,1,'QUICK_LINK','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,28,1,'FRONT_BRAKE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,29,1,'REAR_BRAKE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,30,1,'FRONT_PADS','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,31,1,'REAR_PADS','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,34,1,'BATTERY','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,1,1,'FRAME','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,16,1,'SHIFTERS','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,17,1,'FRONT_DERAILLEUR','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,18,1,'REAR_DERAILLEUR','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,19,1,'PULLEY_UPPER','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,20,1,'PULLEY_LOWER','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,21,1,'CRANKSET','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,22,1,'CHAINRING_OUTER','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,23,1,'CHAINRING_INNER','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,24,1,'BOTTOM_BRACKET','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,26,1,'CHAIN','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,27,1,'QUICK_LINK','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,28,1,'FRONT_BRAKE','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,29,1,'REAR_BRAKE','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,34,1,'BATTERY','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,2,2,'FRAME','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,9,2,'FRONT_WHEEL','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,11,2,'TIRE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,12,2,'TUBE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,49,2,'ROTOR','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,10,2,'REAR_WHEEL','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,13,2,'TIRE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,14,2,'TUBE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,42,2,'CASSETTE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,50,2,'ROTOR','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,35,2,'SHIFTERS','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,36,2,'REAR_DERAILLEUR','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,37,2,'PULLEY_UPPER','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,38,2,'PULLEY_LOWER','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,39,2,'CRANKSET','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,40,2,'CHAINRING_OUTER','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,41,2,'BOTTOM_BRACKET','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,43,2,'CHAIN','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,44,2,'QUICK_LINK','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,45,2,'FRONT_BRAKE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,46,2,'REAR_BRAKE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,47,2,'FRONT_PADS','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,48,2,'REAR_PADS','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,51,2,'SHIFT_CABLE_REAR','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,52,2,'SHIFT_HOUSING_REAR','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,1,1,'FRAME','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,15,1,'WHEELSET','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,3,1,'FRONT_WHEEL','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,5,1,'TIRE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,6,1,'TUBE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,32,1,'ROTOR','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,4,1,'REAR_WHEEL','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,7,1,'TIRE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,25,1,'CASSETTE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,33,1,'ROTOR','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,53,1,'TUBE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,16,1,'SHIFTERS','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,17,1,'FRONT_DERAILLEUR','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,18,1,'REAR_DERAILLEUR','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,19,1,'PULLEY_UPPER','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,20,1,'PULLEY_LOWER','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,21,1,'CRANKSET','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,22,1,'CHAINRING_OUTER','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,23,1,'CHAINRING_INNER','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,24,1,'BOTTOM_BRACKET','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,26,1,'CHAIN','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,27,1,'QUICK_LINK','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,28,1,'FRONT_BRAKE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,29,1,'REAR_BRAKE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,30,1,'FRONT_PADS','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,31,1,'REAR_PADS','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,34,1,'BATTERY','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,2,2,'FRAME','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,9,2,'FRONT_WHEEL','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,11,2,'TIRE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,12,2,'TUBE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,49,2,'ROTOR','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,10,2,'REAR_WHEEL','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,13,2,'TIRE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,14,2,'TUBE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,42,2,'CASSETTE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,50,2,'ROTOR','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,35,2,'SHIFTERS','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,36,2,'REAR_DERAILLEUR','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,37,2,'PULLEY_UPPER','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,38,2,'PULLEY_LOWER','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,39,2,'CRANKSET','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,40,2,'CHAINRING_OUTER','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,41,2,'BOTTOM_BRACKET','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,43,2,'CHAIN','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,44,2,'QUICK_LINK','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,45,2,'FRONT_BRAKE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,46,2,'REAR_BRAKE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,47,2,'FRONT_PADS','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,48,2,'REAR_PADS','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,51,2,'SHIFT_CABLE_REAR','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,52,2,'SHIFT_HOUSING_REAR','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,1,1,'FRAME','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,15,1,'WHEELSET','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,3,1,'FRONT_WHEEL','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,5,1,'TIRE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,6,1,'TUBE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,32,1,'ROTOR','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,4,1,'REAR_WHEEL','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,7,1,'TIRE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,25,1,'CASSETTE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,33,1,'ROTOR','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,53,1,'TUBE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,16,1,'SHIFTERS','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,17,1,'FRONT_DERAILLEUR','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,18,1,'REAR_DERAILLEUR','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,19,1,'PULLEY_UPPER','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,20,1,'PULLEY_LOWER','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,21,1,'CRANKSET','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,22,1,'CHAINRING_OUTER','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,23,1,'CHAINRING_INNER','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,24,1,'BOTTOM_BRACKET','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,26,1,'CHAIN','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,27,1,'QUICK_LINK','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,28,1,'FRONT_BRAKE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,29,1,'REAR_BRAKE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,30,1,'FRONT_PADS','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,31,1,'REAR_PADS','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,34,1,'BATTERY','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,1,1,'FRAME','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,15,1,'WHEELSET','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,3,1,'FRONT_WHEEL','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,5,1,'TIRE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,6,1,'TUBE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,32,1,'ROTOR','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,4,1,'REAR_WHEEL','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,7,1,'TIRE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,25,1,'CASSETTE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,33,1,'ROTOR','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,53,1,'TUBE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,16,1,'SHIFTERS','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,17,1,'FRONT_DERAILLEUR','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,18,1,'REAR_DERAILLEUR','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,19,1,'PULLEY_UPPER','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,20,1,'PULLEY_LOWER','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,21,1,'CRANKSET','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,22,1,'CHAINRING_OUTER','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,23,1,'CHAINRING_INNER','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,24,1,'BOTTOM_BRACKET','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,26,1,'CHAIN','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,27,1,'QUICK_LINK','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,28,1,'FRONT_BRAKE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,29,1,'REAR_BRAKE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,30,1,'FRONT_PADS','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,31,1,'REAR_PADS','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,34,1,'BATTERY','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,2,2,'FRAME','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,9,2,'FRONT_WHEEL','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,11,2,'TIRE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,12,2,'TUBE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,49,2,'ROTOR','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,10,2,'REAR_WHEEL','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,13,2,'TIRE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,14,2,'TUBE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,42,2,'CASSETTE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,50,2,'ROTOR','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,35,2,'SHIFTERS','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,36,2,'REAR_DERAILLEUR','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,37,2,'PULLEY_UPPER','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,38,2,'PULLEY_LOWER','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,39,2,'CRANKSET','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,40,2,'CHAINRING_OUTER','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,41,2,'BOTTOM_BRACKET','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,43,2,'CHAIN','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,44,2,'QUICK_LINK','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,45,2,'FRONT_BRAKE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,46,2,'REAR_BRAKE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,47,2,'FRONT_PADS','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,48,2,'REAR_PADS','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,51,2,'SHIFT_CABLE_REAR','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,52,2,'SHIFT_HOUSING_REAR','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,1,1,'FRAME','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,15,1,'WHEELSET','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,3,1,'FRONT_WHEEL','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,5,1,'TIRE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,6,1,'TUBE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,32,1,'ROTOR','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,4,1,'REAR_WHEEL','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,7,1,'TIRE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,25,1,'CASSETTE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,33,1,'ROTOR','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,53,1,'TUBE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,16,1,'SHIFTERS','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,17,1,'FRONT_DERAILLEUR','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,18,1,'REAR_DERAILLEUR','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,19,1,'PULLEY_UPPER','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,20,1,'PULLEY_LOWER','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,21,1,'CRANKSET','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,22,1,'CHAINRING_OUTER','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,23,1,'CHAINRING_INNER','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,24,1,'BOTTOM_BRACKET','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,26,1,'CHAIN','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,27,1,'QUICK_LINK','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,28,1,'FRONT_BRAKE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,29,1,'REAR_BRAKE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,30,1,'FRONT_PADS','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,31,1,'REAR_PADS','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,34,1,'BATTERY','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,1,1,'FRAME','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,15,1,'WHEELSET','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,3,1,'FRONT_WHEEL','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,5,1,'TIRE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,6,1,'TUBE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,32,1,'ROTOR','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,4,1,'REAR_WHEEL','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,7,1,'TIRE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,25,1,'CASSETTE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,33,1,'ROTOR','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,53,1,'TUBE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,16,1,'SHIFTERS','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,17,1,'FRONT_DERAILLEUR','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,18,1,'REAR_DERAILLEUR','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,19,1,'PULLEY_UPPER','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,20,1,'PULLEY_LOWER','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,21,1,'CRANKSET','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,22,1,'CHAINRING_OUTER','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,23,1,'CHAINRING_INNER','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,24,1,'BOTTOM_BRACKET','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,26,1,'CHAIN','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,27,1,'QUICK_LINK','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,28,1,'FRONT_BRAKE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,29,1,'REAR_BRAKE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,30,1,'FRONT_PADS','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,31,1,'REAR_PADS','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,34,1,'BATTERY','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,1,1,'FRAME','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,15,1,'WHEELSET','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,3,1,'FRONT_WHEEL','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,5,1,'TIRE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,6,1,'TUBE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,32,1,'ROTOR','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,4,1,'REAR_WHEEL','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,7,1,'TIRE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,25,1,'CASSETTE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,33,1,'ROTOR','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,53,1,'TUBE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,16,1,'SHIFTERS','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,17,1,'FRONT_DERAILLEUR','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,18,1,'REAR_DERAILLEUR','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,19,1,'PULLEY_UPPER','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,20,1,'PULLEY_LOWER','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,21,1,'CRANKSET','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,22,1,'CHAINRING_OUTER','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,23,1,'CHAINRING_INNER','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,24,1,'BOTTOM_BRACKET','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,26,1,'CHAIN','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,27,1,'QUICK_LINK','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,28,1,'FRONT_BRAKE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,29,1,'REAR_BRAKE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,30,1,'FRONT_PADS','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,31,1,'REAR_PADS','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,34,1,'BATTERY','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,2,2,'FRAME','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,9,2,'FRONT_WHEEL','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,11,2,'TIRE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,12,2,'TUBE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,49,2,'ROTOR','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,10,2,'REAR_WHEEL','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,13,2,'TIRE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,14,2,'TUBE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,42,2,'CASSETTE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,50,2,'ROTOR','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,35,2,'SHIFTERS','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,36,2,'REAR_DERAILLEUR','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,37,2,'PULLEY_UPPER','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,38,2,'PULLEY_LOWER','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,39,2,'CRANKSET','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,40,2,'CHAINRING_OUTER','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,41,2,'BOTTOM_BRACKET','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,43,2,'CHAIN','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,44,2,'QUICK_LINK','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,45,2,'FRONT_BRAKE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,46,2,'REAR_BRAKE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,47,2,'FRONT_PADS','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,48,2,'REAR_PADS','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,51,2,'SHIFT_CABLE_REAR','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,52,2,'SHIFT_HOUSING_REAR','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,1,1,'FRAME','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,15,1,'WHEELSET','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,3,1,'FRONT_WHEEL','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,5,1,'TIRE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,6,1,'TUBE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,32,1,'ROTOR','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,4,1,'REAR_WHEEL','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,7,1,'TIRE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,25,1,'CASSETTE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,33,1,'ROTOR','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,53,1,'TUBE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,16,1,'SHIFTERS','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,17,1,'FRONT_DERAILLEUR','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,18,1,'REAR_DERAILLEUR','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,19,1,'PULLEY_UPPER','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,20,1,'PULLEY_LOWER','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,21,1,'CRANKSET','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,22,1,'CHAINRING_OUTER','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,23,1,'CHAINRING_INNER','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,24,1,'BOTTOM_BRACKET','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,26,1,'CHAIN','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,27,1,'QUICK_LINK','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,28,1,'FRONT_BRAKE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,29,1,'REAR_BRAKE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,30,1,'FRONT_PADS','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,31,1,'REAR_PADS','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,34,1,'BATTERY','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,1,1,'FRAME','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,15,1,'WHEELSET','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,3,1,'FRONT_WHEEL','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,5,1,'TIRE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,6,1,'TUBE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,32,1,'ROTOR','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,4,1,'REAR_WHEEL','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,7,1,'TIRE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,25,1,'CASSETTE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,33,1,'ROTOR','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,53,1,'TUBE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,16,1,'SHIFTERS','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,17,1,'FRONT_DERAILLEUR','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,18,1,'REAR_DERAILLEUR','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,19,1,'PULLEY_UPPER','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,20,1,'PULLEY_LOWER','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,21,1,'CRANKSET','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,22,1,'CHAINRING_OUTER','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,23,1,'CHAINRING_INNER','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,24,1,'BOTTOM_BRACKET','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,26,1,'CHAIN','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,27,1,'QUICK_LINK','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,28,1,'FRONT_BRAKE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,29,1,'REAR_BRAKE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,30,1,'FRONT_PADS','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,31,1,'REAR_PADS','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,34,1,'BATTERY','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,1,1,'FRAME','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,15,1,'WHEELSET','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,3,1,'FRONT_WHEEL','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,5,1,'TIRE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,6,1,'TUBE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,32,1,'ROTOR','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,4,1,'REAR_WHEEL','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,7,1,'TIRE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,25,1,'CASSETTE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,33,1,'ROTOR','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,53,1,'TUBE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,16,1,'SHIFTERS','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,17,1,'FRONT_DERAILLEUR','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,18,1,'REAR_DERAILLEUR','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,19,1,'PULLEY_UPPER','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,20,1,'PULLEY_LOWER','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,21,1,'CRANKSET','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,22,1,'CHAINRING_OUTER','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,23,1,'CHAINRING_INNER','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,24,1,'BOTTOM_BRACKET','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,26,1,'CHAIN','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,27,1,'QUICK_LINK','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,28,1,'FRONT_BRAKE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,29,1,'REAR_BRAKE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,30,1,'FRONT_PADS','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,31,1,'REAR_PADS','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,34,1,'BATTERY','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,2,2,'FRAME','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,9,2,'FRONT_WHEEL','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,11,2,'TIRE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,12,2,'TUBE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,49,2,'ROTOR','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,10,2,'REAR_WHEEL','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,13,2,'TIRE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,14,2,'TUBE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,42,2,'CASSETTE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,50,2,'ROTOR','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,35,2,'SHIFTERS','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,36,2,'REAR_DERAILLEUR','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,37,2,'PULLEY_UPPER','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,38,2,'PULLEY_LOWER','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,39,2,'CRANKSET','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,40,2,'CHAINRING_OUTER','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,41,2,'BOTTOM_BRACKET','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,43,2,'CHAIN','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,44,2,'QUICK_LINK','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,45,2,'FRONT_BRAKE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,46,2,'REAR_BRAKE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,47,2,'FRONT_PADS','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,48,2,'REAR_PADS','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,51,2,'SHIFT_CABLE_REAR','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,52,2,'SHIFT_HOUSING_REAR','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,1,1,'FRAME','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,16,1,'SHIFTERS','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,17,1,'FRONT_DERAILLEUR','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,18,1,'REAR_DERAILLEUR','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,19,1,'PULLEY_UPPER','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,20,1,'PULLEY_LOWER','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,21,1,'CRANKSET','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,22,1,'CHAINRING_OUTER','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,23,1,'CHAINRING_INNER','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,24,1,'BOTTOM_BRACKET','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,26,1,'CHAIN','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,27,1,'QUICK_LINK','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,28,1,'FRONT_BRAKE','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,29,1,'REAR_BRAKE','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,34,1,'BATTERY','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,1,1,'FRAME','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,15,1,'WHEELSET','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,3,1,'FRONT_WHEEL','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,5,1,'TIRE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,6,1,'TUBE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,32,1,'ROTOR','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,4,1,'REAR_WHEEL','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,7,1,'TIRE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,25,1,'CASSETTE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,33,1,'ROTOR','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,53,1,'TUBE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,16,1,'SHIFTERS','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,17,1,'FRONT_DERAILLEUR','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,18,1,'REAR_DERAILLEUR','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,19,1,'PULLEY_UPPER','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,20,1,'PULLEY_LOWER','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,21,1,'CRANKSET','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,22,1,'CHAINRING_OUTER','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,23,1,'CHAINRING_INNER','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,24,1,'BOTTOM_BRACKET','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,26,1,'CHAIN','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,27,1,'QUICK_LINK','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,28,1,'FRONT_BRAKE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,29,1,'REAR_BRAKE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,30,1,'FRONT_PADS','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,31,1,'REAR_PADS','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,34,1,'BATTERY','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,1,1,'FRAME','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,15,1,'WHEELSET','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,3,1,'FRONT_WHEEL','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,5,1,'TIRE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,6,1,'TUBE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,32,1,'ROTOR','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,4,1,'REAR_WHEEL','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,7,1,'TIRE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,25,1,'CASSETTE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,33,1,'ROTOR','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,53,1,'TUBE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,16,1,'SHIFTERS','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,17,1,'FRONT_DERAILLEUR','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,18,1,'REAR_DERAILLEUR','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,19,1,'PULLEY_UPPER','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,20,1,'PULLEY_LOWER','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,21,1,'CRANKSET','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,22,1,'CHAINRING_OUTER','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,23,1,'CHAINRING_INNER','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,24,1,'BOTTOM_BRACKET','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,26,1,'CHAIN','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,27,1,'QUICK_LINK','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,28,1,'FRONT_BRAKE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,29,1,'REAR_BRAKE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,30,1,'FRONT_PADS','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,31,1,'REAR_PADS','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,34,1,'BATTERY','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,1,1,'FRAME','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,15,1,'WHEELSET','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,3,1,'FRONT_WHEEL','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,5,1,'TIRE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,6,1,'TUBE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,32,1,'ROTOR','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,4,1,'REAR_WHEEL','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,7,1,'TIRE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,25,1,'CASSETTE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,33,1,'ROTOR','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,53,1,'TUBE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,16,1,'SHIFTERS','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,17,1,'FRONT_DERAILLEUR','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,18,1,'REAR_DERAILLEUR','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,19,1,'PULLEY_UPPER','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,20,1,'PULLEY_LOWER','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,21,1,'CRANKSET','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,22,1,'CHAINRING_OUTER','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,23,1,'CHAINRING_INNER','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,24,1,'BOTTOM_BRACKET','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,26,1,'CHAIN','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,27,1,'QUICK_LINK','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,28,1,'FRONT_BRAKE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,29,1,'REAR_BRAKE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,30,1,'FRONT_PADS','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,31,1,'REAR_PADS','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,34,1,'BATTERY','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,1,1,'FRAME','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,15,1,'WHEELSET','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,3,1,'FRONT_WHEEL','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,5,1,'TIRE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,6,1,'TUBE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,32,1,'ROTOR','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,4,1,'REAR_WHEEL','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,7,1,'TIRE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,25,1,'CASSETTE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,33,1,'ROTOR','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,53,1,'TUBE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,16,1,'SHIFTERS','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,17,1,'FRONT_DERAILLEUR','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,18,1,'REAR_DERAILLEUR','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,19,1,'PULLEY_UPPER','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,20,1,'PULLEY_LOWER','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,21,1,'CRANKSET','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,22,1,'CHAINRING_OUTER','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,23,1,'CHAINRING_INNER','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,24,1,'BOTTOM_BRACKET','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,26,1,'CHAIN','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,27,1,'QUICK_LINK','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,28,1,'FRONT_BRAKE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,29,1,'REAR_BRAKE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,30,1,'FRONT_PADS','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,31,1,'REAR_PADS','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,34,1,'BATTERY','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,2,2,'FRAME','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,9,2,'FRONT_WHEEL','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,11,2,'TIRE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,12,2,'TUBE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,49,2,'ROTOR','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,10,2,'REAR_WHEEL','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,13,2,'TIRE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,14,2,'TUBE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,42,2,'CASSETTE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,50,2,'ROTOR','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,35,2,'SHIFTERS','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,36,2,'REAR_DERAILLEUR','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,37,2,'PULLEY_UPPER','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,38,2,'PULLEY_LOWER','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,39,2,'CRANKSET','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,40,2,'CHAINRING_OUTER','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,41,2,'BOTTOM_BRACKET','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,43,2,'CHAIN','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,44,2,'QUICK_LINK','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,45,2,'FRONT_BRAKE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,46,2,'REAR_BRAKE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,47,2,'FRONT_PADS','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,48,2,'REAR_PADS','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,51,2,'SHIFT_CABLE_REAR','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,52,2,'SHIFT_HOUSING_REAR','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,1,1,'FRAME','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,15,1,'WHEELSET','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,3,1,'FRONT_WHEEL','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,5,1,'TIRE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,6,1,'TUBE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,32,1,'ROTOR','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,4,1,'REAR_WHEEL','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,7,1,'TIRE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,25,1,'CASSETTE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,33,1,'ROTOR','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,53,1,'TUBE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,16,1,'SHIFTERS','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,17,1,'FRONT_DERAILLEUR','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,18,1,'REAR_DERAILLEUR','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,19,1,'PULLEY_UPPER','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,20,1,'PULLEY_LOWER','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,21,1,'CRANKSET','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,22,1,'CHAINRING_OUTER','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,23,1,'CHAINRING_INNER','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,24,1,'BOTTOM_BRACKET','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,26,1,'CHAIN','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,27,1,'QUICK_LINK','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,28,1,'FRONT_BRAKE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,29,1,'REAR_BRAKE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,30,1,'FRONT_PADS','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,31,1,'REAR_PADS','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,34,1,'BATTERY','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,1,1,'FRAME','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,16,1,'SHIFTERS','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,17,1,'FRONT_DERAILLEUR','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,18,1,'REAR_DERAILLEUR','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,19,1,'PULLEY_UPPER','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,20,1,'PULLEY_LOWER','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,21,1,'CRANKSET','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,22,1,'CHAINRING_OUTER','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,23,1,'CHAINRING_INNER','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,24,1,'BOTTOM_BRACKET','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,26,1,'CHAIN','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,27,1,'QUICK_LINK','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,28,1,'FRONT_BRAKE','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,29,1,'REAR_BRAKE','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,34,1,'BATTERY','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,2,2,'FRAME','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,9,2,'FRONT_WHEEL','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,11,2,'TIRE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,12,2,'TUBE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,49,2,'ROTOR','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,10,2,'REAR_WHEEL','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,13,2,'TIRE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,14,2,'TUBE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,42,2,'CASSETTE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,50,2,'ROTOR','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,35,2,'SHIFTERS','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,36,2,'REAR_DERAILLEUR','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,37,2,'PULLEY_UPPER','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,38,2,'PULLEY_LOWER','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,39,2,'CRANKSET','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,40,2,'CHAINRING_OUTER','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,41,2,'BOTTOM_BRACKET','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,43,2,'CHAIN','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,44,2,'QUICK_LINK','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,45,2,'FRONT_BRAKE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,46,2,'REAR_BRAKE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,47,2,'FRONT_PADS','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,48,2,'REAR_PADS','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,51,2,'SHIFT_CABLE_REAR','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,52,2,'SHIFT_HOUSING_REAR','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
CREATE TABLE usage_profile (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	code VARCHAR(48) NOT NULL, 
	name TEXT NOT NULL, 
	kind VARCHAR(16) NOT NULL, 
	excluded_slots_json TEXT NOT NULL, 
	excluded_types_json TEXT NOT NULL, 
	notes TEXT, 
	PRIMARY KEY (id), 
	CONSTRAINT ck_profile_kind CHECK (kind IN ('OUTDOOR','TRAINER')), 
	UNIQUE (code), 
	UNIQUE (uuid)
);
INSERT INTO "usage_profile" VALUES(1,'3a559de4-4adc-4201-bde5-f0108979ac2d','OUTDOOR','Outdoor','OUTDOOR','[]','[]','');
INSERT INTO "usage_profile" VALUES(2,'a7423c63-9f7f-4f03-a17c-f5a742e09a10','DIRECT_DRIVE_TRAINER','Direct-drive trainer (wheels off)','TRAINER','["WHEELSET", "FRONT_WHEEL", "REAR_WHEEL", "CASSETTE"]','["BRAKE_PADS", "TIRE", "BRAKE_ROTOR"]','Rear wheel and cassette are removed; the trainer has its own cassette. Front wheel, tires, rotors and pads do not wear.');
CREATE TABLE work_session (
	id INTEGER NOT NULL, 
	uuid VARCHAR(36) NOT NULL, 
	performed_at VARCHAR(20) NOT NULL, 
	performed_on VARCHAR(10) NOT NULL, 
	bike_id INTEGER, 
	title TEXT, 
	notes TEXT, 
	created_at VARCHAR(20) NOT NULL, 
	undone_at VARCHAR(20), 
	undo_reason TEXT, 
	PRIMARY KEY (id), 
	FOREIGN KEY(bike_id) REFERENCES bike (id), 
	UNIQUE (uuid)
);
INSERT INTO "work_session" VALUES(1,'1fe5a339-ff4a-4a38-9731-8f810b17eb59','2026-08-19','2026-08-19',1,'Ultegra Di2 groupset',NULL,'2026-11-14T18:52:46Z',NULL,NULL);
INSERT INTO "work_session" VALUES(2,'add4e3de-6aa5-45a8-8db3-226d5002fe34','2026-08-19','2026-08-19',2,'GRX 1×12 groupset',NULL,'2026-11-14T18:52:46Z',NULL,NULL);
CREATE INDEX ix_import_batch_file_sha256 ON import_batch (file_sha256);
CREATE INDEX ix_ride_bike_sort ON ride (bike_id, sort_utc);
CREATE INDEX ix_installation_bike_id ON installation (bike_id);
CREATE INDEX ix_installation_component_id ON installation (component_id);
CREATE INDEX ix_installation_parent_component_id ON installation (parent_component_id);
CREATE UNIQUE INDEX uq_installation_open_bike_slot ON installation (bike_id, slot) WHERE removed_utc IS NULL AND voided_at IS NULL AND bike_id IS NOT NULL;
CREATE UNIQUE INDEX uq_installation_open_component ON installation (component_id) WHERE removed_utc IS NULL AND voided_at IS NULL;
CREATE UNIQUE INDEX uq_installation_open_parent_slot ON installation (parent_component_id, slot) WHERE removed_utc IS NULL AND voided_at IS NULL AND parent_component_id IS NOT NULL;
CREATE INDEX ix_event_component_action ON maintenance_event (component_id, action_code, sort_utc);
CREATE INDEX ix_ride_flag_ride_id ON ride_flag (ride_id);
CREATE INDEX ix_usage_adjustment_bike_id ON usage_adjustment (bike_id);
CREATE INDEX ix_usage_adjustment_component_id ON usage_adjustment (component_id);
CREATE INDEX ix_contribution_component ON usage_contribution (component_id, sort_utc);
CREATE TRIGGER trg_installation_overlap_ins BEFORE INSERT ON installation
    WHEN NEW.voided_at IS NULL
    BEGIN
        SELECT RAISE(ABORT, 'CONFLICT: component already installed in an overlapping period')
        WHERE EXISTS (SELECT 1 FROM installation i
                      WHERE i.component_id = NEW.component_id AND i.voided_at IS NULL
                        AND i.installed_utc < COALESCE(NEW.removed_utc, '9999-12-31T00:00:00Z')
                        AND NEW.installed_utc < COALESCE(i.removed_utc, '9999-12-31T00:00:00Z'));
        SELECT RAISE(ABORT, 'CONFLICT: slot already occupied in an overlapping period')
        WHERE EXISTS (SELECT 1 FROM installation i
                      WHERE i.voided_at IS NULL AND i.slot = NEW.slot
                        AND ((NEW.bike_id IS NOT NULL AND i.bike_id = NEW.bike_id)
                          OR (NEW.parent_component_id IS NOT NULL AND i.parent_component_id = NEW.parent_component_id))
                        AND i.installed_utc < COALESCE(NEW.removed_utc, '9999-12-31T00:00:00Z')
                        AND NEW.installed_utc < COALESCE(i.removed_utc, '9999-12-31T00:00:00Z'));
    END;
CREATE TRIGGER trg_installation_overlap_upd BEFORE UPDATE ON installation
    WHEN NEW.voided_at IS NULL
    BEGIN
        SELECT RAISE(ABORT, 'CONFLICT: component already installed in an overlapping period')
        WHERE EXISTS (SELECT 1 FROM installation i
                      WHERE i.id <> NEW.id AND i.component_id = NEW.component_id AND i.voided_at IS NULL
                        AND i.installed_utc < COALESCE(NEW.removed_utc, '9999-12-31T00:00:00Z')
                        AND NEW.installed_utc < COALESCE(i.removed_utc, '9999-12-31T00:00:00Z'));
        SELECT RAISE(ABORT, 'CONFLICT: slot already occupied in an overlapping period')
        WHERE EXISTS (SELECT 1 FROM installation i
                      WHERE i.id <> NEW.id AND i.voided_at IS NULL AND i.slot = NEW.slot
                        AND ((NEW.bike_id IS NOT NULL AND i.bike_id = NEW.bike_id)
                          OR (NEW.parent_component_id IS NOT NULL AND i.parent_component_id = NEW.parent_component_id))
                        AND i.installed_utc < COALESCE(NEW.removed_utc, '9999-12-31T00:00:00Z')
                        AND NEW.installed_utc < COALESCE(i.removed_utc, '9999-12-31T00:00:00Z'));
    END;
CREATE TRIGGER trg_bike_no_delete BEFORE DELETE ON bike
    WHEN EXISTS (SELECT 1 FROM ride WHERE bike_id = OLD.id)
      OR EXISTS (SELECT 1 FROM installation WHERE bike_id = OLD.id)
    BEGIN
        SELECT RAISE(ABORT, 'PROTECTED: bike has history; retire it instead');
    END;
CREATE TRIGGER trg_maintenance_no_delete BEFORE DELETE ON maintenance_event
    BEGIN
        SELECT RAISE(ABORT, 'PROTECTED: maintenance events are voided, not deleted');
    END;
CREATE INDEX ix_component_disposition_component_id ON component_disposition (component_id);
CREATE INDEX ix_product_compatibility_product_id ON product_compatibility (product_id);
CREATE INDEX ix_maintenance_event_work_session_id ON maintenance_event (work_session_id);
CREATE INDEX ix_consumable_txn_consumable_id ON consumable_txn (consumable_id);
CREATE INDEX ix_consumable_txn_work_session_id ON consumable_txn (work_session_id);
CREATE TRIGGER trg_consumable_tracking_mode_insert BEFORE INSERT ON consumable
            FOR EACH ROW WHEN NEW.tracking_mode NOT IN ('COUNTED','BULK')
            BEGIN SELECT RAISE(ABORT, 'INVALID: consumable.tracking_mode must be one of (COUNTED,BULK)'); END;
CREATE TRIGGER trg_consumable_tracking_mode_update BEFORE UPDATE ON consumable
            FOR EACH ROW WHEN NEW.tracking_mode NOT IN ('COUNTED','BULK')
            BEGIN SELECT RAISE(ABORT, 'INVALID: consumable.tracking_mode must be one of (COUNTED,BULK)'); END;
CREATE TRIGGER trg_component_disposition_no_delete BEFORE DELETE ON component_disposition
    BEGIN SELECT RAISE(ABORT, 'PROTECTED: disposition history cannot be deleted'); END;
CREATE INDEX ix_journal_entry_bike_id ON journal_entry (bike_id);
CREATE INDEX ix_journal_entry_component_id ON journal_entry (component_id);
CREATE TRIGGER trg_journal_entry_no_delete BEFORE DELETE ON journal_entry
    BEGIN SELECT RAISE(ABORT, 'PROTECTED: journal entries cannot be deleted; void them instead'); END;
CREATE INDEX ix_change_log_bike_id ON change_log (bike_id);
CREATE INDEX ix_change_log_component_id ON change_log (component_id);
CREATE TRIGGER trg_change_log_no_delete BEFORE DELETE ON change_log
    BEGIN SELECT RAISE(ABORT, 'PROTECTED: the change log cannot be deleted'); END;
CREATE TRIGGER trg_change_log_no_update BEFORE UPDATE ON change_log
    BEGIN SELECT RAISE(ABORT, 'PROTECTED: the change log cannot be changed'); END;
CREATE TRIGGER trg_purchase_bundle_no_delete BEFORE DELETE ON purchase_bundle
    BEGIN SELECT RAISE(ABORT, 'PROTECTED: bundles cannot be deleted; void them instead'); END;
CREATE INDEX ix_journal_entry_ride_id ON journal_entry (ride_id);
CREATE UNIQUE INDEX uq_rule_component_code ON service_rule (component_id, rule_code) WHERE component_id IS NOT NULL;
CREATE UNIQUE INDEX uq_rule_type_code ON service_rule (component_type, rule_code) WHERE component_type IS NOT NULL;
CREATE UNIQUE INDEX uq_rule_bike_code ON service_rule (bike_id, rule_code) WHERE bike_id IS NOT NULL;
CREATE TRIGGER trg_service_rule_requires_setup_insert BEFORE INSERT ON service_rule
        FOR EACH ROW WHEN NEW.requires_setup IS NOT NULL AND NEW.requires_setup NOT IN ('TUBE','TUBELESS','TUBULAR','ELECTRONIC','MECHANICAL')
        BEGIN SELECT RAISE(ABORT, 'INVALID: service_rule.requires_setup must be TUBE, TUBELESS, TUBULAR, ELECTRONIC or MECHANICAL'); END;
CREATE TRIGGER trg_service_rule_requires_setup_update BEFORE UPDATE ON service_rule
        FOR EACH ROW WHEN NEW.requires_setup IS NOT NULL AND NEW.requires_setup NOT IN ('TUBE','TUBELESS','TUBULAR','ELECTRONIC','MECHANICAL')
        BEGIN SELECT RAISE(ABORT, 'INVALID: service_rule.requires_setup must be TUBE, TUBELESS, TUBULAR, ELECTRONIC or MECHANICAL'); END;
CREATE INDEX ix_reminder_snooze_component_id ON reminder_snooze (component_id);
CREATE INDEX ix_reminder_snooze_bike_id ON reminder_snooze (bike_id);
CREATE INDEX ix_journal_entry_incident_group ON journal_entry (incident_group);
CREATE TRIGGER trg_component_disposition_disposition_insert BEFORE INSERT ON component_disposition
            FOR EACH ROW WHEN NEW.disposition NOT IN ('STORED','AWAITING_SERVICE','RETIRED','DISCARDED','SOLD','VOIDED','IN_USE','WARRANTY_RETURN')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component_disposition.disposition must be one of (STORED,AWAITING_SERVICE,RETIRED,DISCARDED,SOLD,VOIDED,IN_USE,WARRANTY_RETURN)'); END;
CREATE TRIGGER trg_component_disposition_disposition_update BEFORE UPDATE ON component_disposition
            FOR EACH ROW WHEN NEW.disposition NOT IN ('STORED','AWAITING_SERVICE','RETIRED','DISCARDED','SOLD','VOIDED','IN_USE','WARRANTY_RETURN')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component_disposition.disposition must be one of (STORED,AWAITING_SERVICE,RETIRED,DISCARDED,SOLD,VOIDED,IN_USE,WARRANTY_RETURN)'); END;
CREATE INDEX ix_service_order_component_id ON service_order (component_id);
CREATE TRIGGER trg_service_order_no_delete BEFORE DELETE ON service_order
    BEGIN SELECT RAISE(ABORT, 'PROTECTED: service orders cannot be deleted; they are voided instead'); END;
CREATE INDEX ix_pick_list_item_list_code ON pick_list_item (list_code);
CREATE INDEX ix_component_component_type ON component (component_type);
CREATE TRIGGER trg_component_no_delete BEFORE DELETE ON component
    WHEN EXISTS (SELECT 1 FROM installation WHERE component_id = OLD.id)
      OR EXISTS (SELECT 1 FROM maintenance_event WHERE component_id = OLD.id)
      OR EXISTS (SELECT 1 FROM usage_contribution WHERE component_id = OLD.id)
    BEGIN
        SELECT RAISE(ABORT, 'PROTECTED: component has history; retire it instead');
    END;
CREATE TRIGGER trg_component_tire_setup_insert BEFORE INSERT ON component
            FOR EACH ROW WHEN NEW.tire_setup IS NOT NULL AND NEW.tire_setup NOT IN ('TUBE','TUBELESS','TUBULAR')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component.tire_setup must be TUBE, TUBELESS or TUBULAR'); END;
CREATE TRIGGER trg_component_tire_setup_update BEFORE UPDATE ON component
            FOR EACH ROW WHEN NEW.tire_setup IS NOT NULL AND NEW.tire_setup NOT IN ('TUBE','TUBELESS','TUBULAR')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component.tire_setup must be TUBE, TUBELESS or TUBULAR'); END;
CREATE INDEX ix_component_bundle_id ON component (bundle_id);
CREATE TRIGGER trg_component_disposition_insert BEFORE INSERT ON component
            FOR EACH ROW WHEN NEW.disposition NOT IN ('STORED','AWAITING_SERVICE','RETIRED','DISCARDED','SOLD','VOIDED','IN_USE','WARRANTY_RETURN')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component.disposition must be one of (STORED,AWAITING_SERVICE,RETIRED,DISCARDED,SOLD,VOIDED,IN_USE,WARRANTY_RETURN)'); END;
CREATE TRIGGER trg_component_disposition_update BEFORE UPDATE ON component
            FOR EACH ROW WHEN NEW.disposition NOT IN ('STORED','AWAITING_SERVICE','RETIRED','DISCARDED','SOLD','VOIDED','IN_USE','WARRANTY_RETURN')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component.disposition must be one of (STORED,AWAITING_SERVICE,RETIRED,DISCARDED,SOLD,VOIDED,IN_USE,WARRANTY_RETURN)'); END;
CREATE UNIQUE INDEX uq_component_type_label ON component (component_type, label) WHERE component_type NOT IN ('TIRE', 'INNER_TUBE');
COMMIT;
