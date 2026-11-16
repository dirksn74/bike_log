-- Bike Log 2026-11-15-0024 (schema revision 0024), demo/sample data made by that version's own code.
BEGIN TRANSACTION;
CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL, 
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);
INSERT INTO "alembic_version" VALUES('0024');
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
INSERT INTO "bike" VALUES(1,'80748967-6f31-4d30-90f8-0fbc59b18776','Aurora SL','Sample','Aurora SL',2026,'ACTIVE',NULL,'Sample data (made up). Settings → Fresh start removes it.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',249900,'2026-02-27',NULL,NULL,NULL);
INSERT INTO "bike" VALUES(2,'540bf1d2-9cc1-4ef4-9c2f-203682fa8907','Winter Allroad','Sample','Allroad',2023,'ACTIVE',NULL,'Sample data (made up). Settings → Fresh start removes it.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,'MECHANICAL',NULL,NULL);
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
INSERT INTO "change_log" VALUES(1,'2026-11-16T17:09:57Z',1,NULL,'CREATED',NULL,NULL,'Aurora SL','SAMPLE','demo');
INSERT INTO "change_log" VALUES(2,'2026-11-16T17:09:57Z',NULL,1,'CREATED',NULL,NULL,'Frame and fork Aurora SL frame','SAMPLE','demo');
INSERT INTO "change_log" VALUES(3,'2026-11-16T17:09:57Z',1,1,'INSTALLED',NULL,NULL,'Aurora SL (frame) from 2026-02-27','SAMPLE','demo');
INSERT INTO "change_log" VALUES(4,'2026-11-16T17:09:57Z',2,NULL,'CREATED',NULL,NULL,'Winter Allroad','SAMPLE','demo');
INSERT INTO "change_log" VALUES(5,'2026-11-16T17:09:57Z',NULL,2,'CREATED',NULL,NULL,'Frame and fork Winter Allroad frame','SAMPLE','demo');
INSERT INTO "change_log" VALUES(6,'2026-11-16T17:09:57Z',2,2,'INSTALLED',NULL,NULL,'Winter Allroad (frame) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(7,'2026-11-16T17:09:57Z',NULL,3,'CREATED',NULL,NULL,'Front wheel DT Swiss ARC 1400 front (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(8,'2026-11-16T17:09:57Z',NULL,4,'CREATED',NULL,NULL,'Rear wheel DT Swiss ARC 1400 rear (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(9,'2026-11-16T17:09:57Z',NULL,4,'CHANGED','history before tracking','unknown','recorded','SAMPLE','demo');
INSERT INTO "change_log" VALUES(10,'2026-11-16T17:09:57Z',1,3,'INSTALLED',NULL,NULL,'Aurora SL (front wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(11,'2026-11-16T17:09:57Z',NULL,5,'CREATED',NULL,NULL,'Tire GP5000 32 mm front (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(12,'2026-11-16T17:09:57Z',NULL,5,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 front (Aurora SL) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(13,'2026-11-16T17:09:57Z',NULL,6,'CREATED',NULL,NULL,'Inner tube tube front (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(14,'2026-11-16T17:09:57Z',NULL,6,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 front (Aurora SL) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(15,'2026-11-16T17:09:57Z',1,4,'INSTALLED',NULL,NULL,'Aurora SL (rear wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(16,'2026-11-16T17:09:57Z',NULL,7,'CREATED',NULL,NULL,'Tire GP5000 32 mm rear (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(17,'2026-11-16T17:09:57Z',NULL,7,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(18,'2026-11-16T17:09:57Z',NULL,8,'CREATED',NULL,NULL,'Inner tube tube rear (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(19,'2026-11-16T17:09:57Z',NULL,8,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(20,'2026-11-16T17:09:57Z',NULL,9,'CREATED',NULL,NULL,'Front wheel Alloy front (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(21,'2026-11-16T17:09:57Z',NULL,10,'CREATED',NULL,NULL,'Rear wheel Alloy rear (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(22,'2026-11-16T17:09:57Z',2,9,'INSTALLED',NULL,NULL,'Winter Allroad (front wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(23,'2026-11-16T17:09:57Z',NULL,11,'CREATED',NULL,NULL,'Tire GP5000 32 mm front (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(24,'2026-11-16T17:09:57Z',NULL,11,'INSTALLED',NULL,NULL,'Alloy front (Winter Allroad) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(25,'2026-11-16T17:09:57Z',NULL,12,'CREATED',NULL,NULL,'Inner tube tube front (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(26,'2026-11-16T17:09:57Z',NULL,12,'INSTALLED',NULL,NULL,'Alloy front (Winter Allroad) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(27,'2026-11-16T17:09:57Z',2,10,'INSTALLED',NULL,NULL,'Winter Allroad (rear wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(28,'2026-11-16T17:09:57Z',NULL,13,'CREATED',NULL,NULL,'Tire GP5000 32 mm rear (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(29,'2026-11-16T17:09:57Z',NULL,13,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(30,'2026-11-16T17:09:57Z',NULL,14,'CREATED',NULL,NULL,'Inner tube tube rear (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(31,'2026-11-16T17:09:57Z',NULL,14,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(32,'2026-11-16T17:09:57Z',NULL,15,'CREATED',NULL,NULL,'Wheelset DT Swiss ARC 1400 wheelset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(33,'2026-11-16T17:09:57Z',1,3,'REMOVED',NULL,'Aurora SL (front wheel)','on 2026-08-20 · moved','SAMPLE','demo');
INSERT INTO "change_log" VALUES(34,'2026-11-16T17:09:57Z',1,4,'REMOVED',NULL,'Aurora SL (rear wheel)','on 2026-08-20 · moved','SAMPLE','demo');
INSERT INTO "change_log" VALUES(35,'2026-11-16T17:09:57Z',1,15,'INSTALLED',NULL,NULL,'Aurora SL (wheelset) from 2026-08-20','SAMPLE','demo');
INSERT INTO "change_log" VALUES(36,'2026-11-16T17:09:57Z',NULL,3,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 wheelset (front wheel) from 2026-08-20','SAMPLE','demo');
INSERT INTO "change_log" VALUES(37,'2026-11-16T17:09:57Z',NULL,4,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 wheelset (rear wheel) from 2026-08-20','SAMPLE','demo');
INSERT INTO "change_log" VALUES(38,'2026-11-16T17:09:57Z',NULL,16,'CREATED',NULL,NULL,'Shifters Ultegra Di2 levers','SAMPLE','demo');
INSERT INTO "change_log" VALUES(39,'2026-11-16T17:09:57Z',1,16,'INSTALLED',NULL,NULL,'Aurora SL (shifters) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(40,'2026-11-16T17:09:57Z',NULL,17,'CREATED',NULL,NULL,'Front derailleur Ultegra front derailleur','SAMPLE','demo');
INSERT INTO "change_log" VALUES(41,'2026-11-16T17:09:57Z',1,17,'INSTALLED',NULL,NULL,'Aurora SL (front derailleur) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(42,'2026-11-16T17:09:57Z',NULL,18,'CREATED',NULL,NULL,'Rear derailleur Ultegra rear derailleur','SAMPLE','demo');
INSERT INTO "change_log" VALUES(43,'2026-11-16T17:09:57Z',1,18,'INSTALLED',NULL,NULL,'Aurora SL (rear derailleur) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(44,'2026-11-16T17:09:57Z',NULL,19,'CREATED',NULL,NULL,'Pulley wheel Ultegra upper pulley (guide)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(45,'2026-11-16T17:09:57Z',NULL,19,'INSTALLED',NULL,NULL,'Ultegra rear derailleur (pulley upper) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(46,'2026-11-16T17:09:57Z',NULL,20,'CREATED',NULL,NULL,'Pulley wheel Ultegra lower pulley (tension)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(47,'2026-11-16T17:09:57Z',NULL,20,'INSTALLED',NULL,NULL,'Ultegra rear derailleur (pulley lower) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(48,'2026-11-16T17:09:57Z',NULL,21,'CREATED',NULL,NULL,'Crankset Ultegra crankset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(49,'2026-11-16T17:09:57Z',1,21,'INSTALLED',NULL,NULL,'Aurora SL (crankset) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(50,'2026-11-16T17:09:57Z',NULL,22,'CREATED',NULL,NULL,'Chainring Ultegra outer chainring 52T','SAMPLE','demo');
INSERT INTO "change_log" VALUES(51,'2026-11-16T17:09:57Z',NULL,22,'INSTALLED',NULL,NULL,'Ultegra crankset (chainring outer) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(52,'2026-11-16T17:09:57Z',NULL,23,'CREATED',NULL,NULL,'Chainring Ultegra inner chainring 36T','SAMPLE','demo');
INSERT INTO "change_log" VALUES(53,'2026-11-16T17:09:57Z',NULL,23,'INSTALLED',NULL,NULL,'Ultegra crankset (chainring inner) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(54,'2026-11-16T17:09:57Z',NULL,24,'CREATED',NULL,NULL,'Bottom bracket Ultegra bottom bracket','SAMPLE','demo');
INSERT INTO "change_log" VALUES(55,'2026-11-16T17:09:57Z',1,24,'INSTALLED',NULL,NULL,'Aurora SL (bottom bracket) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(56,'2026-11-16T17:09:57Z',NULL,25,'CREATED',NULL,NULL,'Cassette Ultegra cassette 11-34','SAMPLE','demo');
INSERT INTO "change_log" VALUES(57,'2026-11-16T17:09:57Z',NULL,25,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (cassette) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(58,'2026-11-16T17:09:57Z',NULL,26,'CREATED',NULL,NULL,'Chain Ultegra chain','SAMPLE','demo');
INSERT INTO "change_log" VALUES(59,'2026-11-16T17:09:57Z',1,26,'INSTALLED',NULL,NULL,'Aurora SL (chain) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(60,'2026-11-16T17:09:57Z',NULL,26,'CHANGED','chain rotation of bike',NULL,'Aurora SL','SAMPLE','demo');
INSERT INTO "change_log" VALUES(61,'2026-11-16T17:09:57Z',NULL,27,'CREATED',NULL,NULL,'Quick link Ultegra quick link','SAMPLE','demo');
INSERT INTO "change_log" VALUES(62,'2026-11-16T17:09:57Z',NULL,27,'INSTALLED',NULL,NULL,'Ultegra chain (quick link) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(63,'2026-11-16T17:09:57Z',NULL,28,'CREATED',NULL,NULL,'Brake circuit (hydraulic) Ultegra front brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(64,'2026-11-16T17:09:57Z',1,28,'INSTALLED',NULL,NULL,'Aurora SL (front brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(65,'2026-11-16T17:09:57Z',NULL,29,'CREATED',NULL,NULL,'Brake circuit (hydraulic) Ultegra rear brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(66,'2026-11-16T17:09:57Z',1,29,'INSTALLED',NULL,NULL,'Aurora SL (rear brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(67,'2026-11-16T17:09:57Z',NULL,30,'CREATED',NULL,NULL,'Brake pads Ultegra front pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(68,'2026-11-16T17:09:57Z',1,30,'INSTALLED',NULL,NULL,'Aurora SL (front pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(69,'2026-11-16T17:09:57Z',NULL,31,'CREATED',NULL,NULL,'Brake pads Ultegra rear pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(70,'2026-11-16T17:09:57Z',1,31,'INSTALLED',NULL,NULL,'Aurora SL (rear pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(71,'2026-11-16T17:09:57Z',NULL,32,'CREATED',NULL,NULL,'Brake rotor Ultegra front rotor 160 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(72,'2026-11-16T17:09:57Z',NULL,32,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 front (Aurora SL) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(73,'2026-11-16T17:09:57Z',NULL,33,'CREATED',NULL,NULL,'Brake rotor Ultegra rear rotor 140 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(74,'2026-11-16T17:09:57Z',NULL,33,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(75,'2026-11-16T17:09:57Z',NULL,34,'CREATED',NULL,NULL,'Battery (Di2/AXS) Ultegra Di2 battery','SAMPLE','demo');
INSERT INTO "change_log" VALUES(76,'2026-11-16T17:09:57Z',1,34,'INSTALLED',NULL,NULL,'Aurora SL (battery) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(77,'2026-11-16T17:09:57Z',NULL,34,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(78,'2026-11-16T17:09:57Z',NULL,27,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(79,'2026-11-16T17:09:57Z',NULL,21,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(80,'2026-11-16T17:09:57Z',NULL,28,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(81,'2026-11-16T17:09:57Z',NULL,16,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(82,'2026-11-16T17:09:57Z',NULL,22,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(83,'2026-11-16T17:09:57Z',NULL,29,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(84,'2026-11-16T17:09:57Z',NULL,23,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(85,'2026-11-16T17:09:57Z',NULL,30,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(86,'2026-11-16T17:09:57Z',NULL,24,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(87,'2026-11-16T17:09:57Z',NULL,17,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(88,'2026-11-16T17:09:57Z',NULL,25,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(89,'2026-11-16T17:09:57Z',NULL,18,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(90,'2026-11-16T17:09:57Z',NULL,32,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(91,'2026-11-16T17:09:57Z',NULL,31,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(92,'2026-11-16T17:09:57Z',NULL,26,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(93,'2026-11-16T17:09:57Z',NULL,19,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(94,'2026-11-16T17:09:57Z',NULL,33,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(95,'2026-11-16T17:09:57Z',NULL,20,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(96,'2026-11-16T17:09:57Z',NULL,35,'CREATED',NULL,NULL,'Shifters GRX levers','SAMPLE','demo');
INSERT INTO "change_log" VALUES(97,'2026-11-16T17:09:57Z',2,35,'INSTALLED',NULL,NULL,'Winter Allroad (shifters) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(98,'2026-11-16T17:09:57Z',NULL,36,'CREATED',NULL,NULL,'Rear derailleur GRX rear derailleur','SAMPLE','demo');
INSERT INTO "change_log" VALUES(99,'2026-11-16T17:09:57Z',2,36,'INSTALLED',NULL,NULL,'Winter Allroad (rear derailleur) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(100,'2026-11-16T17:09:57Z',NULL,37,'CREATED',NULL,NULL,'Pulley wheel GRX upper pulley (guide)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(101,'2026-11-16T17:09:57Z',NULL,37,'INSTALLED',NULL,NULL,'GRX rear derailleur (pulley upper) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(102,'2026-11-16T17:09:57Z',NULL,38,'CREATED',NULL,NULL,'Pulley wheel GRX lower pulley (tension)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(103,'2026-11-16T17:09:57Z',NULL,38,'INSTALLED',NULL,NULL,'GRX rear derailleur (pulley lower) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(104,'2026-11-16T17:09:57Z',NULL,39,'CREATED',NULL,NULL,'Crankset GRX crankset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(105,'2026-11-16T17:09:57Z',2,39,'INSTALLED',NULL,NULL,'Winter Allroad (crankset) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(106,'2026-11-16T17:09:57Z',NULL,40,'CREATED',NULL,NULL,'Chainring GRX chainring 40T','SAMPLE','demo');
INSERT INTO "change_log" VALUES(107,'2026-11-16T17:09:57Z',NULL,40,'INSTALLED',NULL,NULL,'GRX crankset (chainring outer) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(108,'2026-11-16T17:09:57Z',NULL,41,'CREATED',NULL,NULL,'Bottom bracket GRX bottom bracket','SAMPLE','demo');
INSERT INTO "change_log" VALUES(109,'2026-11-16T17:09:57Z',2,41,'INSTALLED',NULL,NULL,'Winter Allroad (bottom bracket) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(110,'2026-11-16T17:09:57Z',NULL,42,'CREATED',NULL,NULL,'Cassette GRX cassette 10-45','SAMPLE','demo');
INSERT INTO "change_log" VALUES(111,'2026-11-16T17:09:57Z',NULL,42,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (cassette) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(112,'2026-11-16T17:09:57Z',NULL,43,'CREATED',NULL,NULL,'Chain GRX chain','SAMPLE','demo');
INSERT INTO "change_log" VALUES(113,'2026-11-16T17:09:57Z',2,43,'INSTALLED',NULL,NULL,'Winter Allroad (chain) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(114,'2026-11-16T17:09:57Z',NULL,43,'CHANGED','chain rotation of bike',NULL,'Winter Allroad','SAMPLE','demo');
INSERT INTO "change_log" VALUES(115,'2026-11-16T17:09:57Z',NULL,44,'CREATED',NULL,NULL,'Quick link GRX quick link','SAMPLE','demo');
INSERT INTO "change_log" VALUES(116,'2026-11-16T17:09:57Z',NULL,44,'INSTALLED',NULL,NULL,'GRX chain (quick link) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(117,'2026-11-16T17:09:57Z',NULL,45,'CREATED',NULL,NULL,'Brake circuit (hydraulic) GRX front brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(118,'2026-11-16T17:09:57Z',2,45,'INSTALLED',NULL,NULL,'Winter Allroad (front brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(119,'2026-11-16T17:09:57Z',NULL,46,'CREATED',NULL,NULL,'Brake circuit (hydraulic) GRX rear brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(120,'2026-11-16T17:09:57Z',2,46,'INSTALLED',NULL,NULL,'Winter Allroad (rear brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(121,'2026-11-16T17:09:57Z',NULL,47,'CREATED',NULL,NULL,'Brake pads GRX front pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(122,'2026-11-16T17:09:57Z',2,47,'INSTALLED',NULL,NULL,'Winter Allroad (front pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(123,'2026-11-16T17:09:57Z',NULL,48,'CREATED',NULL,NULL,'Brake pads GRX rear pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(124,'2026-11-16T17:09:57Z',2,48,'INSTALLED',NULL,NULL,'Winter Allroad (rear pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(125,'2026-11-16T17:09:57Z',NULL,49,'CREATED',NULL,NULL,'Brake rotor GRX front rotor 160 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(126,'2026-11-16T17:09:57Z',NULL,49,'INSTALLED',NULL,NULL,'Alloy front (Winter Allroad) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(127,'2026-11-16T17:09:57Z',NULL,50,'CREATED',NULL,NULL,'Brake rotor GRX rear rotor 160 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(128,'2026-11-16T17:09:57Z',NULL,50,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(129,'2026-11-16T17:09:57Z',NULL,51,'CREATED',NULL,NULL,'Shift cable GRX rear shift cable','SAMPLE','demo');
INSERT INTO "change_log" VALUES(130,'2026-11-16T17:09:57Z',2,51,'INSTALLED',NULL,NULL,'Winter Allroad (shift cable rear) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(131,'2026-11-16T17:09:57Z',NULL,52,'CREATED',NULL,NULL,'Shift housing GRX rear shift housing','SAMPLE','demo');
INSERT INTO "change_log" VALUES(132,'2026-11-16T17:09:57Z',2,52,'INSTALLED',NULL,NULL,'Winter Allroad (shift housing rear) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(133,'2026-11-16T17:09:57Z',NULL,53,'CREATED',NULL,NULL,'Inner tube Sample Road tube 700×28-32','SAMPLE','demo');
INSERT INTO "change_log" VALUES(134,'2026-11-16T17:09:57Z',NULL,8,'REMOVED',NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tube)','on 2026-08-22T10:00:00Z · Awaiting inspection or repair','SAMPLE','demo');
INSERT INTO "change_log" VALUES(135,'2026-11-16T17:09:57Z',NULL,8,'CHANGED','state when not installed','Stored as a reusable spare','Awaiting inspection or repair','SAMPLE','demo');
INSERT INTO "change_log" VALUES(136,'2026-11-16T17:09:57Z',NULL,53,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tube) from 2026-08-22T10:00:00Z','SAMPLE','demo');
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
INSERT INTO "component" VALUES(1,'2c428896-2738-4674-9a0a-6f124dd14b72','FRAME','Aurora SL frame',NULL,NULL,'RECORDED',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(2,'9e63def6-308f-4a8a-be3d-b661d408638e','FRAME','Winter Allroad frame',NULL,NULL,'RECORDED',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(3,'49c057f6-a4d3-4474-9038-55bb13145c13','FRONT_WHEEL','DT Swiss ARC 1400 front (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(4,'edbd8a18-74b7-4f10-b69b-e81d22a88576','REAR_WHEEL','DT Swiss ARC 1400 rear (Aurora SL)',NULL,NULL,'RECORDED','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(5,'fb6e1f1d-199a-4b1f-8711-7a7cadfb2192','TIRE','GP5000 32 mm front (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(6,'ba2a87e9-dbb1-4841-90e2-4adff7613225','INNER_TUBE','tube front (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(7,'ee9ec358-0d44-4ac2-9f96-bc7987fa0b5b','TIRE','GP5000 32 mm rear (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(8,'94fd78b5-b5af-4532-8bc3-029e46a6dc1e','INNER_TUBE','tube rear (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','AWAITING_SERVICE','2026-08-22',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(9,'b53f2dc2-69dd-4cf3-8e82-df8aa7f448d4','FRONT_WHEEL','Alloy front (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(10,'b3115103-c7d1-4044-8c77-c8445d97e0af','REAR_WHEEL','Alloy rear (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(11,'dcce4678-a38a-4984-b73e-65aea4299d4e','TIRE','GP5000 32 mm front (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(12,'58304ad3-a21d-439e-aba7-149f119235f0','INNER_TUBE','tube front (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(13,'a2d8c152-b6a3-4cda-a0ed-d788b0e0fc59','TIRE','GP5000 32 mm rear (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(14,'1ef5dab3-0ebe-4fad-960c-475df057d5ec','INNER_TUBE','tube rear (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(15,'1506533e-9e1a-4a7c-bd65-c01282582b2b','WHEELSET','DT Swiss ARC 1400 wheelset',NULL,NULL,'NEW',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(16,'81774c4b-6e36-4617-a736-cd9606e55362','SHIFTERS','Ultegra Di2 levers',1,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(17,'bb6e35c4-580e-4482-857e-dc608fbaae78','FRONT_DERAILLEUR','Ultegra front derailleur',2,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(18,'c5ddddaa-dc07-4c98-a98d-85a038870e6d','REAR_DERAILLEUR','Ultegra rear derailleur',3,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(19,'4ea1d96e-329a-4ee2-832d-fdca02114890','PULLEY_WHEEL','Ultegra upper pulley (guide)',4,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(20,'c44b7d3e-1f98-4b0b-b31c-90ae181f4a21','PULLEY_WHEEL','Ultegra lower pulley (tension)',5,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(21,'4e6cca77-5bd1-423d-895a-49788b0b10c8','CRANKSET','Ultegra crankset',6,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(22,'b7284ab3-cfff-4442-ad8a-36328dc00185','CHAINRING','Ultegra outer chainring 52T',7,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(23,'27efc2df-ab7f-4700-9863-fee1fa547de4','CHAINRING','Ultegra inner chainring 36T',8,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(24,'5185d832-7456-4b01-beef-d1285a7c1b7f','BOTTOM_BRACKET','Ultegra bottom bracket',9,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(25,'441852b3-aec5-4abe-b73b-2fd46df52f86','CASSETTE','Ultegra cassette 11-34',10,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(26,'d3033c58-013a-4efa-9a86-3a2b50ba73f9','CHAIN','Ultegra chain',11,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,1,NULL,NULL);
INSERT INTO "component" VALUES(27,'e84f230d-8353-4056-9d0b-37e9dd58aa26','QUICK_LINK','Ultegra quick link',12,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(28,'4dd7f61d-5004-4534-be65-b619f4f602c4','BRAKE_CIRCUIT','Ultegra front brake',13,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(29,'6ea262ec-f4f1-4b51-bf23-e19c1f692ce3','BRAKE_CIRCUIT','Ultegra rear brake',14,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(30,'85a94b97-a1ff-4e63-8acc-8bcca77a05d3','BRAKE_PADS','Ultegra front pads',15,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(31,'8bcea129-3901-4b2c-9d1e-51b2dc7ec3a9','BRAKE_PADS','Ultegra rear pads',15,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(32,'536d7a85-2fd8-4556-95d2-f2a63cc1ee6d','BRAKE_ROTOR','Ultegra front rotor 160 mm',16,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(33,'39eaa912-a91b-478f-ac06-7f3e7a5e89ef','BRAKE_ROTOR','Ultegra rear rotor 140 mm',17,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(34,'d9d0cd13-e8ce-40ee-8b8b-c69a771b0a5e','BATTERY','Ultegra Di2 battery',18,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(35,'19014e0e-28d8-4542-a983-0358fb9d4455','SHIFTERS','GRX levers',19,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(36,'19c5ef36-ecca-4ca0-ae1d-46a7483a27f3','REAR_DERAILLEUR','GRX rear derailleur',20,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(37,'a08e1907-e37c-4ede-b7fc-6e0b88e1040f','PULLEY_WHEEL','GRX upper pulley (guide)',21,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(38,'fd9a31ed-6e6b-483e-9145-759e65ca7efb','PULLEY_WHEEL','GRX lower pulley (tension)',22,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(39,'98f5260c-2b03-47a3-8906-7f4c6d1ba25c','CRANKSET','GRX crankset',23,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(40,'0c7a69ae-8268-492e-8dac-ffdef366adcb','CHAINRING','GRX chainring 40T',24,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(41,'478ccb41-e8c6-449c-af9e-e116db690ecb','BOTTOM_BRACKET','GRX bottom bracket',9,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(42,'a4db56e8-0859-47c0-b3cb-101a4976470f','CASSETTE','GRX cassette 10-45',25,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(43,'fdc49bcd-793a-459b-afdb-14ad3a567d98','CHAIN','GRX chain',11,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,2,NULL,NULL);
INSERT INTO "component" VALUES(44,'7fda86f1-2f0e-4c09-b08a-7c3ff52d27a1','QUICK_LINK','GRX quick link',12,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(45,'3d69f5ff-b362-4a4f-82d6-c2c545ccf697','BRAKE_CIRCUIT','GRX front brake',26,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(46,'a5927dde-b0dd-4134-a452-25cdc2d11fa8','BRAKE_CIRCUIT','GRX rear brake',27,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(47,'a2b9654b-ff55-48cd-8530-20ad8d8467b5','BRAKE_PADS','GRX front pads',15,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(48,'fbdeed8d-71f0-4b78-a77c-f95eaaab8946','BRAKE_PADS','GRX rear pads',15,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(49,'b1af1eba-f4b9-46a4-931a-b1ac981418fb','BRAKE_ROTOR','GRX front rotor 160 mm',28,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(50,'81fad5e5-dbab-46ad-954e-ec6813825707','BRAKE_ROTOR','GRX rear rotor 160 mm',28,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(51,'46d9aac7-0bfb-4861-b527-7554876c2445','SHIFT_CABLE','GRX rear shift cable',29,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(52,'496069a4-1603-4d56-a913-05c279fd6411','SHIFT_HOUSING','GRX rear shift housing',30,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(53,'4cd6ef54-f32c-4056-8465-c2618ebfed87','INNER_TUBE','Sample Road tube 700×28-32',31,NULL,'NEW',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','{}','STORED',NULL,NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO "component_disposition" VALUES(1,8,'AWAITING_SERVICE','STORED','2026-08-22','pinch flat',NULL,'2026-11-16T17:09:57Z',NULL);
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
INSERT INTO "consumable" VALUES(1,'3046b9dc-23d7-4138-a2b7-a3bb1bc6c28c','WAX','Hot wax (sample)',NULL,'g',1,NULL,'2026-11-16T17:09:57Z','BULK',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable" VALUES(2,'654a6c8d-9cf0-4719-a80c-0ce4be89c1ac','WAX','Wax drip (sample)',NULL,'ml',0,NULL,'2026-11-16T17:09:57Z','BULK',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable" VALUES(3,'eb635bf1-baa7-4e77-ac1e-78ac13f85bbb','PART','Inner tube — Sample Road tube 700×28-32',NULL,'tube',1,NULL,'2026-11-16T17:09:57Z','COUNTED',NULL,'INNER_TUBE',31,'one tube','Garage shelf',2.0);
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
INSERT INTO "consumable_txn" VALUES(1,1,'PURCHASE',500.0,'2026-08-16',NULL,3999,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(2,3,'PURCHASE',3.0,'2026-08-16',NULL,2097,NULL,'2026-11-16T17:09:57Z',NULL,NULL,3,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(3,1,'USE',30.0,'2026-08-19',1,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(4,2,'USE',NULL,'2026-09-05',4,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(5,1,'USE',30.0,'2026-09-20',5,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(6,3,'USE',1.0,'2026-08-22',NULL,NULL,'taken from stock to install','2026-11-16T17:09:57Z',NULL,53,NULL,NULL,NULL);
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
INSERT INTO "installation" VALUES(1,'7b1d6cd4-8622-4311-a176-3423e506e669',1,1,NULL,'FRAME','2026-02-27','2026-02-26T23:00:00Z',NULL,NULL,NULL,'Added with the bike (frame and fork are parts)',NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(2,'520f4caa-0b49-4bcd-8602-cd4b5c94845c',2,2,NULL,'FRAME','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,'Added with the bike (frame and fork are parts)',NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(3,'5ec97858-0d7e-48e8-8a18-13f36c66be76',3,1,NULL,'FRONT_WHEEL','2026-08-19','2026-08-18T22:00:00Z','2026-08-20','2026-08-19T22:00:00Z','put into a wheelset',NULL,NULL,NULL,'2026-11-16T17:09:57Z','MOVED',NULL,NULL,NULL);
INSERT INTO "installation" VALUES(4,'4f4091e0-6122-4332-a9b7-d4b3e3c55090',5,NULL,3,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(5,'1f2f367c-9655-4dc5-97e8-b2e5f1283924',6,NULL,3,'TUBE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(6,'048c712e-9eac-40fb-9c9a-2032cccee464',4,1,NULL,'REAR_WHEEL','2026-08-19','2026-08-18T22:00:00Z','2026-08-20','2026-08-19T22:00:00Z','put into a wheelset',NULL,NULL,NULL,'2026-11-16T17:09:57Z','MOVED',NULL,NULL,NULL);
INSERT INTO "installation" VALUES(7,'b1694177-f722-452b-93d2-0a5d134a6436',7,NULL,4,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(8,'4aa1dbfd-a298-4ffb-8cb4-f59c9e00e2a2',8,NULL,4,'TUBE','2026-08-19','2026-08-18T22:00:00Z','2026-08-22T10:00:00Z','2026-08-22T10:00:00Z','pinch flat',NULL,NULL,NULL,'2026-11-16T17:09:57Z','AWAITING_SERVICE',NULL,NULL,NULL);
INSERT INTO "installation" VALUES(9,'16d996eb-8a77-4d3f-98ad-ec24738a57ff',9,2,NULL,'FRONT_WHEEL','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(10,'ddaa2622-9836-4027-b9b3-d3f1a3251a13',11,NULL,9,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(11,'90c724e8-850d-44ed-b79b-45d28a403b58',12,NULL,9,'TUBE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(12,'606742fd-9bc4-43ed-99a6-f91079d7308c',10,2,NULL,'REAR_WHEEL','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(13,'70c647e6-5e33-4f6c-9eb7-de92a8b3b98a',13,NULL,10,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(14,'3e2a4f9b-5eb4-49a4-8b38-be8695580426',14,NULL,10,'TUBE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(15,'8b23cd20-0433-4336-98ed-6c1addfdaa93',15,1,NULL,'WHEELSET','2026-08-20','2026-08-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(16,'8e2d29aa-ebc4-4fa8-a583-f9dd93ae87e9',3,NULL,15,'FRONT_WHEEL','2026-08-20','2026-08-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(17,'19e6d561-a493-46d1-9592-9cec777ef325',4,NULL,15,'REAR_WHEEL','2026-08-20','2026-08-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(18,'57d4690a-ce78-4ae9-bf53-dac8563181be',16,1,NULL,'SHIFTERS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(19,'83ddfd90-e89f-44e5-b350-ca698288ee44',17,1,NULL,'FRONT_DERAILLEUR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(20,'75641066-ef76-4de5-8709-9655c0189a0c',18,1,NULL,'REAR_DERAILLEUR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(21,'4d90d346-3b51-4b77-9def-6d61d3f5c96a',19,NULL,18,'PULLEY_UPPER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(22,'9227f244-b128-45d2-8ad4-711eae005e76',20,NULL,18,'PULLEY_LOWER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(23,'9de3249c-68c1-4ec5-ae94-281d52be783c',21,1,NULL,'CRANKSET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(24,'a1c64255-f7dd-478f-ab05-220ac66d6b4e',22,NULL,21,'CHAINRING_OUTER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(25,'16522986-b8bd-44aa-b244-b2c88d552d59',23,NULL,21,'CHAINRING_INNER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(26,'56799ee8-d7d9-4e94-8e8c-2e8c99ed7a7e',24,1,NULL,'BOTTOM_BRACKET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(27,'3c83b4fc-cdd9-44fc-ab64-fe3eb3fc730f',25,NULL,4,'CASSETTE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(28,'63ff91ee-a16b-41ab-b91a-bda302d0ba77',26,1,NULL,'CHAIN','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(29,'0b73f5ef-aff3-4435-98fe-d05a420b6faa',27,NULL,26,'QUICK_LINK','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(30,'5d8aa18d-fddd-4a01-a42d-01323ec25a37',28,1,NULL,'FRONT_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(31,'77267da5-0df1-46bd-a6b8-0d55d265aa52',29,1,NULL,'REAR_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(32,'e9f090ec-7134-4ea0-8e5d-4a6a1dbcd726',30,1,NULL,'FRONT_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(33,'704a1059-09ea-409e-b632-eb4f1798d586',31,1,NULL,'REAR_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(34,'d1ecb549-ac02-4a99-bded-253d6c3e04b1',32,NULL,3,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(35,'3be8321f-73de-4774-bf20-00e9e793dc20',33,NULL,4,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(36,'c63c958f-c27d-4180-8646-2b48598efb2f',34,1,NULL,'BATTERY','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(37,'4913397a-ed15-4d92-bfc4-49163c732836',35,2,NULL,'SHIFTERS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(38,'9399c20a-98e4-4d20-8362-d45ea0c34580',36,2,NULL,'REAR_DERAILLEUR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(39,'013c465b-8397-42d3-892d-82a2417e8481',37,NULL,36,'PULLEY_UPPER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(40,'f91ba677-9efa-4880-8417-5fc027d902ae',38,NULL,36,'PULLEY_LOWER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(41,'48ea73b8-b557-4b92-93c8-e634e71a4099',39,2,NULL,'CRANKSET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(42,'f2b1db5a-6f25-4bda-bd83-434ed894cb2a',40,NULL,39,'CHAINRING_OUTER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(43,'5af381c4-34b9-454c-9962-f0a2739adbed',41,2,NULL,'BOTTOM_BRACKET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(44,'a2696353-780e-471b-9f44-1d27056d9247',42,NULL,10,'CASSETTE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(45,'4b982bea-4dbd-45e1-9490-071db72bfcf2',43,2,NULL,'CHAIN','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(46,'d47a8922-c391-4b01-a592-985c735f184e',44,NULL,43,'QUICK_LINK','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(47,'7115b89e-9b8a-49a7-9760-74fbe118fe03',45,2,NULL,'FRONT_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(48,'010ac58f-98e9-4b4a-8ec4-5c2f16a1f597',46,2,NULL,'REAR_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(49,'f59e2995-1940-42b5-a479-85898ddbb50c',47,2,NULL,'FRONT_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(50,'3a2d3527-a3ad-4986-9971-9d9b07e389fa',48,2,NULL,'REAR_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(51,'1db71c80-11e7-41b4-8222-abbf95609d43',49,NULL,9,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(52,'c6b2729d-9738-4c33-8e46-fa9c2b9600af',50,NULL,10,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(53,'fa4d99ea-7d06-43fb-b4d0-5ecc72525f85',51,2,NULL,'SHIFT_CABLE_REAR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(54,'982128e9-b5dd-461d-884e-13aecf189a6b',52,2,NULL,'SHIFT_HOUSING_REAR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(55,'75203e1b-a7cb-4c1a-9758-50e608006068',53,NULL,4,'TUBE','2026-08-22T10:00:00Z','2026-08-22T10:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL);
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
INSERT INTO "journal_entry" VALUES(1,'31ffea0d-cd13-46fe-844f-824ed0c75adb',1,8,'2026-08-22','ISSUE','Pinch flat on a pothole, swapped the tube at the roadside.','2026-08-22','2026-11-16T17:09:57Z',NULL,NULL,NULL,1,'FLAT','f391b831-5805-4146-b0c0-5462fbfc0778',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "journal_entry" VALUES(2,'cd518745-1bf5-48fb-adb7-55d141675a4e',2,NULL,'2026-09-27','ISSUE','Slid out on wet leaves in a corner; scraped bar tape and rear derailleur.',NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,18,'CRASH','8ec2c016-7859-4112-a271-7c3dd13bda3c',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "journal_entry" VALUES(3,'d099239b-5a48-447d-8cf1-ec20640ee4ee',1,21,'2026-10-15','ISSUE','Creak under load from the bottom bracket area.',NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,25,'DEFECT','6d33610e-b14a-4708-b6a8-0a04f370d4fb',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "journal_entry" VALUES(4,'f6173dd6-f6a3-4b30-842e-cd6ed63480fa',1,NULL,'2026-08-19','NOTE','Fitted 32 mm tires; clearance is fine.',NULL,'2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO "maintenance_event" VALUES(1,'a9924d03-13ca-4daf-995e-4af653c50300','WAX_HOT',26,1,'2026-08-19','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,1,30.0,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(2,'0d250582-bae6-405a-82d0-59492d0e8c57','LUBE',43,2,'2026-08-19','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'wet lube for winter',NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(3,'8c8fa758-ba1a-4829-b463-f8d4def95982','BATTERY_CHARGE',34,1,'2026-08-19','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(4,'ae9e209d-9ccd-4213-928c-2d3c2545a60b','WAX_LIQUID',26,1,'2026-09-05','2026-09-05','2026-09-05T21:59:59Z',NULL,NULL,NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(5,'1d997b03-26b9-4114-88cc-b57ea695982f','WAX_HOT',26,1,'2026-09-20','2026-09-20','2026-09-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,1,30.0,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(6,'d0d18147-5772-4dbc-9052-a69f0227c70f','BATTERY_CHARGE',34,1,'2026-09-20','2026-09-20','2026-09-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(7,'c83397ae-a648-4c8a-9304-96d1081c764f','CHAIN_MEASURE_WEAR',26,1,'2026-09-20','2026-09-20','2026-09-19T22:00:00Z',NULL,NULL,'OK',0.1,'%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(8,'185d7be3-9170-4b37-913e-4efd31b26b2c','PAD_MEASURE',48,2,'2026-09-30','2026-09-30','2026-09-29T22:00:00Z',NULL,NULL,'OK',1.4,'mm',NULL,NULL,NULL,'gritty winter roads',NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(9,'221c720b-86cd-4079-9566-f180c7b3e44b','LUBE',43,2,'2026-09-30','2026-09-30','2026-09-29T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL);
INSERT INTO "maintenance_event" VALUES(10,'d39170c4-ed39-4fd7-8a24-b648c0aec317','FREEHUB_SERVICE',4,1,'2026-08-06','2026-08-06','2026-08-05T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,4500,'done by the seller before the wheel was sold',NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL,NULL);
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
INSERT INTO "pick_list_item" VALUES(1,'230d4283-7334-4458-8a12-5416a4df5deb','SHOP','Sample shop',NULL,NULL,'2026-11-16T17:09:57Z');
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
INSERT INTO "product" VALUES(1,'93403ebc-2a63-44a9-a88a-d797f889fc86','SHIFTERS','Shimano','ST-R8170','{"function": "Dual control levers, 2\u00d712 Di2, hydraulic disc brake", "connection": "Wireless to the derailleurs", "power": "CR1632 coin cell in each lever", "brake fluid": "Shimano mineral oil"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(2,'2275e5fe-61c6-4d4d-8663-2b7305067fce','FRONT_DERAILLEUR','Shimano','FD-R8150','{"speeds": "2\u00d712", "mount": "Braze-on", "max chainring": "52T", "front capacity": "16T", "wire": "EW-SD300"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(3,'8e9705be-aad4-421b-9ba9-c08a214d06ac','REAR_DERAILLEUR','Shimano','RD-R8150','{"speeds": "12", "max low sprocket": "34T", "total capacity": "39T", "charging": "Charging port for EW-EC300", "wire": "EW-SD300"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(4,'e321d037-1258-43c1-81f5-ce582260bdc6','PULLEY_WHEEL','Shimano','RD-R8150 guide pulley','{"speeds": "12", "teeth": "13"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(5,'0b662b8a-145d-46b5-a839-159eb4d35e44','PULLEY_WHEEL','Shimano','RD-R8150 tension pulley','{"speeds": "12", "teeth": "13"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(6,'a016c6b8-ed61-47c5-a06f-0642b9ba4bff','CRANKSET','Shimano','FC-R8100 172.5 mm','{"speeds": "2\u00d712", "crank length": "172.5 mm", "chainrings": "52-36T", "spindle": "Hollowtech II, 24 mm", "power meter": "none"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(7,'de36e0d0-8051-47b6-a085-4c5d1a77fb1c','CHAINRING','Shimano','FC-R8100 chainring 52T','{"teeth": "52", "position": "outer", "for": "FC-R8100 52-36T"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(8,'456db51a-f116-4a80-8797-c5bfa55d8563','CHAINRING','Shimano','FC-R8100 chainring 36T','{"teeth": "36", "position": "inner", "for": "FC-R8100 52-36T"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(9,'17ab42f4-751a-47e2-bab4-15181bc451ac','BOTTOM_BRACKET','Shimano','SM-BB-R60','{"standard": "BSA threaded, 68 mm shell", "spindle": "24 mm (Hollowtech II)"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(10,'ae5393b3-69ff-46fb-b886-4ea85523c3b1','CASSETTE','Shimano','CS-R8100-12 11-34','{"speeds": "12", "range": "11-34T", "sprockets": "11-12-13-14-15-17-19-21-24-27-30-34", "freehub": "Shimano HG 11-speed road (and 12-speed road) freehub"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(11,'45c42a4b-8a63-4616-aa0b-5d2f1d066bb9','CHAIN','Shimano','CN-M8100','{"speeds": "12 (Hyperglide+)", "links": "116 (shorten to fit)", "joining": "Quick link SM-CN910-12"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(12,'6aa488f7-4a22-4aa2-b73d-a859303a7a4c','QUICK_LINK','Shimano','SM-CN910-12','{"speeds": "12", "reuse": "Shimano recommends a new link after opening"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(13,'85d35aa9-a790-442a-9cf0-4dc6649a8852','BRAKE_CIRCUIT','Shimano','BR-R8170 front','{"caliper": "BR-R8170, flat mount, 2 pistons", "lever": "ST-R8170", "hose": "SM-BH90-JK-SSR", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(14,'3edbdf26-793e-45a2-a628-105462bf95b8','BRAKE_CIRCUIT','Shimano','BR-R8170 rear','{"caliper": "BR-R8170, flat mount, 2 pistons", "lever": "ST-R8170", "hose": "SM-BH90-JK-SSR", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(15,'0f2b4a59-60bb-48cf-89e4-95314d87a327','BRAKE_PADS','Shimano','L05A-RF','{"compound": "Resin", "cooling": "Fins", "fits": "BR-R8170 (also K05S-RX resin, no fins)"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(16,'c1717b18-0a4e-44cd-adba-9ad3c5ae0cbf','BRAKE_ROTOR','Shimano','RT-CL800 160 mm','{"size": "160 mm", "mount": "Center Lock", "technology": "Ice Tech Freeza", "alternative": "RT-MT800 (same size) is also listed for this caliper"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(17,'90d59da6-aeee-492a-a200-8eb9213555f6','BRAKE_ROTOR','Shimano','RT-CL800 140 mm','{"size": "140 mm", "mount": "Center Lock", "technology": "Ice Tech Freeza", "alternative": "RT-MT800 (same size) is also listed for this caliper"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(18,'b0e09d29-9b7a-42cc-b97a-0d2fb3233722','BATTERY','Shimano','BT-DN300','{"type": "Internal (seatpost or frame)", "ports": "3 \u00d7 EW-SD300", "charging": "EW-EC300 cable at the rear derailleur port"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(19,'38f0afca-2c4e-43c1-bd97-8ba349eaad9f','SHIFTERS','Shimano','ST-RX820','{"function": "Shift/brake lever right (1\u00d712 mechanical) + brake lever left, hydraulic disc", "brake fluid": "Shimano mineral oil"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(20,'008c6510-502a-4690-8ca5-499071d5452d','REAR_DERAILLEUR','Shimano','RD-RX822-SGS','{"speeds": "12", "max low sprocket": "51T", "clutch": "Shadow RD+"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(21,'e296d77d-78bf-4c6b-ab59-8d1ef5cee882','PULLEY_WHEEL','Shimano','RD-RX822 guide pulley','{"speeds": "12", "teeth": "13"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(22,'17b5d374-2818-40df-8186-49217bdc42cc','PULLEY_WHEEL','Shimano','RD-RX822 tension pulley','{"speeds": "12", "teeth": "13"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(23,'571aae7f-5438-46d3-8be2-8aeb7afdca7e','CRANKSET','Shimano','FC-RX820-1 172.5 mm','{"speeds": "1\u00d712", "crank length": "172.5 mm", "chainring": "40T", "spindle": "Hollowtech II, 24 mm"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(24,'50e91bdc-d9c9-48b8-bc56-89bb407e78b3','CHAINRING','Shimano','SM-CRX820-1 40T','{"teeth": "40", "position": "single (1\u00d7)"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(25,'b2bba6be-452f-43df-82e0-5d8c2aaac156','CASSETTE','Shimano','CS-M8100-12 10-45','{"speeds": "12", "range": "10-45T", "sprockets": "10-12-14-16-18-21-24-28-32-36-40-45", "freehub": "Shimano Micro Spline"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(26,'b2b4bf4b-4fe4-4fb6-9f3b-18f3ffa3188d','BRAKE_CIRCUIT','Shimano','BR-RX820 front','{"caliper": "BR-RX820, flat mount, 2 pistons", "lever": "ST-RX820", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(27,'56eeede4-e1b2-459e-b294-75b68dd6bc39','BRAKE_CIRCUIT','Shimano','BR-RX820 rear','{"caliper": "BR-RX820, flat mount, 2 pistons", "lever": "ST-RX820", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(28,'a77c9373-eee3-493e-98ee-2caebe2d043f','BRAKE_ROTOR','Shimano','RT-MT800 160 mm','{"size": "160 mm", "mount": "Center Lock", "technology": "Ice Tech Freeza"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(29,'de528cb4-bf13-4d05-90a8-129b6fe3a03f','SHIFT_CABLE','Shimano','Shimano shift cable','{"position": "rear"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(30,'a7264dc1-e5fa-41dd-abc9-f54065d1ab29','SHIFT_HOUSING','Shimano','Shimano shift housing','{"position": "rear"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-16T17:09:57Z',NULL);
INSERT INTO "product" VALUES(31,'6fce6bda-71ae-4788-8356-e7ffc1e08086','INNER_TUBE','Sample','Road tube 700×28-32','{}',NULL,NULL,NULL,'2026-11-16T17:09:57Z',NULL);
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
INSERT INTO "purchase_bundle" VALUES(1,'da0b9220-c757-4626-bd0a-efaac4b6a6e4','Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','Sample shop','2026-08-11',165000,NULL,1,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL);
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
INSERT INTO "ride" VALUES(1,'d2ba24cb-dc25-4033-9970-60e16a5e1d05',1,'Coffee ride','2026-08-22',NULL,'2026-08-21T22:00:00Z',78.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(2,'6fbe0e4c-e051-4399-8e83-37c5c55fc0d0',1,'Vineyards','2026-08-25',NULL,'2026-08-24T22:00:00Z',83.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(3,'abb25c57-04e1-49b5-971c-764d71f926d6',1,'Coffee ride','2026-08-27',NULL,'2026-08-26T22:00:00Z',87.2,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(4,'c2220368-48da-4179-bf9b-c27795e21de5',1,'Zwift workout','2026-08-29','2026-08-29T16:30:00Z','2026-08-29T16:30:00Z',38.4,3600,'VirtualRide',2,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL);
INSERT INTO "ride" VALUES(5,'fa58f76b-190d-4712-9ab6-b5cf205d9784',2,'Long Sunday','2026-08-30',NULL,'2026-08-29T22:00:00Z',55.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','WET');
INSERT INTO "ride" VALUES(6,'ef768e30-40c8-4a05-86b7-4abc474b6029',1,'Coffee ride','2026-09-05',NULL,'2026-09-04T22:00:00Z',78.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(7,'1c53f93e-3b09-4cf2-8973-43ac53c061b9',2,'Club ride','2026-09-06',NULL,'2026-09-05T22:00:00Z',66.9,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','WET');
INSERT INTO "ride" VALUES(8,'9c89c12b-f37a-45df-8ebf-8a67de3a15ff',1,'After work','2026-09-10',NULL,'2026-09-09T22:00:00Z',37.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(9,'2ae6b769-70cc-4555-8d4c-c8b935b89d01',1,'Vineyards','2026-09-12',NULL,'2026-09-11T22:00:00Z',84.8,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(10,'a2831057-99aa-499c-9cb2-1ba11430abf1',2,'Recovery spin','2026-09-13',NULL,'2026-09-12T22:00:00Z',80.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(11,'d893c9d1-9052-4270-a291-0279ec5773b5',1,'Recovery spin','2026-09-15',NULL,'2026-09-14T22:00:00Z',106.8,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(12,'aba830f0-cc17-4b4f-8d6d-67ab52a7914b',1,'Hill repeats','2026-09-17',NULL,'2026-09-16T22:00:00Z',37.2,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(13,'0c2ba676-eae3-458d-8ef5-e91a7e6af167',1,'Coffee ride','2026-09-19',NULL,'2026-09-18T22:00:00Z',79.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(14,'3f8fb1e7-f895-4650-bdc2-d7bbf5cc16fb',2,'Hill repeats','2026-09-20',NULL,'2026-09-19T22:00:00Z',47.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(15,'7f2b3391-c6b2-42f9-9cf2-1d660be56321',1,'Gravel detour','2026-09-22',NULL,'2026-09-21T22:00:00Z',92.3,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(16,'1744fd7a-8cac-4d84-8c22-e11f57223147',1,'Gravel detour','2026-09-24',NULL,'2026-09-23T22:00:00Z',81.6,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(17,'eba59604-03cb-41d2-96e1-00af3d1afa42',1,'Club ride','2026-09-26',NULL,'2026-09-25T22:00:00Z',52.2,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','WET');
INSERT INTO "ride" VALUES(18,'cb9f91cc-ec28-4263-b910-15104b1c6ee7',2,'Vineyards','2026-09-27',NULL,'2026-09-26T22:00:00Z',84.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(19,'ffcd1b0b-22ef-49f3-b332-b3d6b14f17a4',1,'Zwift workout','2026-10-01','2026-10-01T16:30:00Z','2026-10-01T16:30:00Z',35.4,3600,'VirtualRide',2,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL);
INSERT INTO "ride" VALUES(20,'ba2399c0-6d56-43dc-bd16-b9bdf3aadf5c',1,'Long Sunday','2026-10-03',NULL,'2026-10-02T22:00:00Z',77.3,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(21,'aba766e7-b148-4709-b568-a6133fe84f97',1,'Coffee ride','2026-10-06',NULL,'2026-10-05T22:00:00Z',112.9,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(22,'e41bc330-985a-45b6-8f46-f9ab198a542b',1,'River path','2026-10-08',NULL,'2026-10-07T22:00:00Z',57.0,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(23,'2534e197-e46e-4800-a9a2-a8bb9b44f623',1,'Club ride','2026-10-10',NULL,'2026-10-09T22:00:00Z',40.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(24,'92a5116f-edfd-4d38-bf07-c3c3faff27d8',2,'Long Sunday','2026-10-11',NULL,'2026-10-10T22:00:00Z',49.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','WET');
INSERT INTO "ride" VALUES(25,'753b08dd-d31e-41c9-b610-aae6e1715e14',1,'Coffee ride','2026-10-15',NULL,'2026-10-14T22:00:00Z',81.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','DRY');
INSERT INTO "ride" VALUES(26,'f9e3a953-00a5-4e06-b25d-8791d14a1b2b',1,'Zwift workout','2026-10-17','2026-10-17T16:30:00Z','2026-10-17T16:30:00Z',25.7,3600,'VirtualRide',2,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL);
INSERT INTO "ride" VALUES(27,'e6684b05-d7e6-4304-8f06-343bbba6f271',2,'After work','2026-10-18',NULL,'2026-10-17T22:00:00Z',53.4,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','WET');
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
        CONSTRAINT ck_rule_trigger CHECK (trigger IN ('INTERVAL','CYCLE_WINDOW','PARENT_COUNT','ONCE_AFTER_INSTALL','LIFETIME')),
        CONSTRAINT ck_rule_count CHECK (trigger <> 'PARENT_COUNT' OR interval_count >= 1),
        CONSTRAINT ck_rule_target CHECK ((component_type IS NOT NULL) + (component_id IS NOT NULL) + (bike_id IS NOT NULL) = 1),
        FOREIGN KEY(component_id) REFERENCES component (id),
        FOREIGN KEY(bike_id) REFERENCES bike (id),
        UNIQUE (uuid),
        CONSTRAINT ck_rule_lifetime CHECK (trigger <> 'LIFETIME' OR interval_km IS NOT NULL)
);
INSERT INTO "service_rule" VALUES(1,'94847335-6687-40e5-be60-522b3399e350','CHAIN_HOT_WAX','Hot wax chain','CHAIN',NULL,NULL,'WAX_HOT','INTERVAL',500.0,NULL,NULL,NULL,NULL,'["WAX_HOT"]',50.0,NULL,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,200.0);
INSERT INTO "service_rule" VALUES(2,'51627c83-6c07-474f-99c0-f7beb73a8a9c','CHAIN_LIQUID_WAX','Liquid-wax top-up','CHAIN',NULL,NULL,'WAX_LIQUID','CYCLE_WINDOW',NULL,NULL,250.0,300.0,'WAX_HOT','["WAX_LIQUID"]',25.0,NULL,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(3,'9c139ce6-be00-4038-a79a-ebb2a91a8721','CHAIN_WEAR_CHECK','Measure chain wear','CHAIN',NULL,NULL,'CHAIN_MEASURE_WEAR','INTERVAL',1000.0,NULL,NULL,NULL,NULL,'["CHAIN_MEASURE_WEAR"]',100.0,NULL,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(4,'ca37ce25-7338-4b4b-9949-48cb298147f8','BRAKE_FLUID','Replace brake fluid','BRAKE_CIRCUIT',NULL,NULL,'BRAKE_FLUID_REPLACE','INTERVAL',NULL,24,NULL,NULL,NULL,'["BRAKE_FLUID_REPLACE"]',NULL,30,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(5,'8062e82f-7a4a-44e2-a1d0-379dc1cd5b46','BRAKE_PAD_CHECK','Check brake pads','BRAKE_PADS',NULL,NULL,'PAD_MEASURE','INTERVAL',1000.0,NULL,NULL,NULL,NULL,'["PAD_MEASURE"]',100.0,NULL,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(6,'d84bef8e-acba-4a99-9b7b-6dec2083e1cc','FRONT_WHEEL_INSPECTION','Inspect wheel','FRONT_WHEEL',NULL,NULL,'WHEEL_INSPECT','INTERVAL',3000.0,12,NULL,NULL,NULL,'["WHEEL_INSPECT"]',200.0,30,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(7,'d1fae523-57b0-49bd-bceb-40dd5f9a946c','REAR_WHEEL_INSPECTION','Inspect wheel','REAR_WHEEL',NULL,NULL,'WHEEL_INSPECT','INTERVAL',3000.0,12,NULL,NULL,NULL,'["WHEEL_INSPECT"]',200.0,30,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(8,'976b3df3-56f0-443b-b8ed-2afec8f63e16','FRONT_HUB_BEARINGS','Service hub bearings','FRONT_WHEEL',NULL,NULL,'HUB_BEARING_SERVICE','INTERVAL',10000.0,NULL,NULL,NULL,NULL,'["HUB_BEARING_SERVICE"]',500.0,NULL,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(9,'15b56a06-6f0f-44f7-abed-7a76ddb0595d','REAR_HUB_BEARINGS','Service hub bearings','REAR_WHEEL',NULL,NULL,'HUB_BEARING_SERVICE','INTERVAL',10000.0,NULL,NULL,NULL,NULL,'["HUB_BEARING_SERVICE"]',500.0,NULL,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(10,'bcd69152-de56-4f2f-a29f-791c1f73ca42','FREEHUB','Service freehub','REAR_WHEEL',NULL,NULL,'FREEHUB_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["FREEHUB_SERVICE"]',300.0,30,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(11,'b82b3dd5-0b3f-43fa-a0ff-96e46c3e6a42','TIRE_CHECK','Inspect tire','TIRE',NULL,NULL,'TIRE_INSPECT','INTERVAL',1000.0,12,NULL,NULL,NULL,'["TIRE_INSPECT"]',100.0,30,'DEFAULT',1,'Yearly also for sidewall cracks from age; no bicycle-tire age limit was found.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(12,'309edaa4-bbcd-4f4a-8bac-d356e3d3e268','TIRE_REPLACE','Replace tire','TIRE',NULL,NULL,'TIRE_INSPECT','LIFETIME',6000.0,NULL,NULL,NULL,NULL,'[]',500.0,NULL,'DEFAULT',1,'Personal value (Dirk 2026-11-15: a tire lasts about 6,000 km). Counts the tire''s own total km on every wheel and bike, km from before included; logging work does not reset it, a new tire starts at 0. Replace sooner when the tread is worn, cut or the sidewalls crack.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(13,'d62d8166-07b3-480b-807c-6ae9a26acd85','TIRE_SEALANT','Top up sealant','TIRE',NULL,NULL,'SEALANT_TOP_UP','INTERVAL',NULL,3,NULL,NULL,NULL,'["SEALANT_TOP_UP", "SEALANT_RENEW"]',NULL,14,'MANUFACTURER',1,'Stan''s: sealant lasts 2–6 months; check every 3 months (stans.com sealant support).','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','TUBELESS',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(14,'b8d8a05a-048b-4628-be7c-5118f9400463','TIRE_SEALANT_RENEW','Clean out and renew sealant','TIRE',NULL,NULL,'SEALANT_RENEW','INTERVAL',NULL,12,NULL,NULL,NULL,'["SEALANT_RENEW"]',NULL,30,'MANUFACTURER',1,'Stan''s: take the tire off and clean out old sealant once a year; check rim tape and valves at the same time (stans.com sealant support).','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','TUBELESS',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(15,'09858b16-bde9-4d8d-a363-5c53d51b8d4e','VALVE_CORE','Replace valve core','TUBELESS_VALVE',NULL,NULL,'VALVE_CORE_REPLACE','INTERVAL',NULL,12,NULL,NULL,NULL,'["VALVE_CORE_REPLACE"]',NULL,30,'DEFAULT',1,'At the yearly sealant clean-out; personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','TUBELESS',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(16,'933c8f92-8569-4f84-b6b4-264715dec8b8','FRONT_THRU_AXLE','Check and grease thru-axle','FRONT_WHEEL',NULL,NULL,'THRU_AXLE_SERVICE','INTERVAL',NULL,6,NULL,NULL,NULL,'["THRU_AXLE_SERVICE"]',NULL,14,'DEFAULT',1,'Personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(17,'f5b18833-71a7-4dff-84f5-bbccf9544d1e','REAR_THRU_AXLE','Check and grease thru-axle','REAR_WHEEL',NULL,NULL,'THRU_AXLE_SERVICE','INTERVAL',NULL,6,NULL,NULL,NULL,'["THRU_AXLE_SERVICE"]',NULL,14,'DEFAULT',1,'Personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(18,'78655a95-b63f-4363-aef5-618204a63207','HEADSET_SERVICE','Service headset','HEADSET',NULL,NULL,'HEADSET_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["HEADSET_SERVICE"]',300.0,30,'DEFAULT',1,NULL,'2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(19,'acfeca3f-4485-4f6e-a5ca-8d8559b5d5ce','DI2_BATTERY_CHARGE','Charge Di2 battery','BATTERY',NULL,NULL,'BATTERY_CHARGE','INTERVAL',800.0,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',100.0,NULL,'DEFAULT',1,'Shimano BT-DN300: about 1000 km per charge (less with much front shifting); 800 km leaves a margin. Source: retailer listings (Rose, Tweeks), not verified with Shimano.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(20,'3d58a517-c8c4-41b5-bbd5-01bcefdcebd7','POWER_METER_CHARGE','Charge power meter','POWER_METER',NULL,NULL,'POWER_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["POWER_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your power meter''s battery life with a margin.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,50.0,10.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(21,'a4f56655-8fe4-483b-adeb-66c240378978','POWER_PEDALS_CHARGE','Charge power-meter pedals','POWER_METER_PEDALS',NULL,NULL,'POWER_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["POWER_CHARGE"]',NULL,NULL,'DEFAULT',1,'Favero Assioma PRO RS-1: at least 60 h per charge (up to about 160 h after a firmware update). 80 h is your choice (2026-10-26). Source: retailer listings quoting Favero, not verified.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,80.0,10.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(22,'7359eeeb-1d17-42e8-9893-6c2ad7826972','SENSOR_BATTERY','Replace sensor battery','SENSOR',NULL,NULL,'COIN_CELL_REPLACE','INTERVAL',NULL,12,NULL,NULL,NULL,'["COIN_CELL_REPLACE"]',NULL,30,'DEFAULT',1,'Magene S3+ (CR2032): about 500 h of riding per battery (retailer listings, not verified with Magene); 400 h leaves a margin. 12 months covers standby drain (your estimate).','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,400.0,40.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(23,'b22b883d-7c56-433d-beaf-21e38318f0c8','SHIFTER_COIN_CELLS','Replace shifter coin cells','SHIFTERS',NULL,NULL,'COIN_CELL_REPLACE','INTERVAL',NULL,18,NULL,NULL,NULL,'["COIN_CELL_REPLACE"]',NULL,30,'DEFAULT',0,'Wireless Di2 levers (CR1632): about 1.5–2 years (retailer listings); 18 months leaves a margin. Off by default (wired and mechanical levers have no coin cell); switch it on for wireless levers. Keep CR1632 cells as counted stock to pick them when logging.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(24,'40a7e2bb-07a6-45ad-999c-6177d8d2e48b','COMPUTER_CHARGE','Charge bike computer','BIKE_COMPUTER',NULL,NULL,'BATTERY_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your device''s battery life with a margin (personal value).','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,20.0,4.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(25,'beb9fc99-8e94-4ceb-af4d-07e5b9243fb3','LIGHT_CHARGE','Charge light','LIGHT',NULL,NULL,'BATTERY_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your light''s run time in the mode you use (personal value).','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,4.0,1.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(26,'5bd0ab4a-5df8-43f1-8060-f820a4b12ca6','RADAR_CHARGE','Charge radar','RADAR',NULL,NULL,'BATTERY_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your radar''s run time in the mode you use (personal value).','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,6.0,2.0,NULL,NULL);
INSERT INTO "service_rule" VALUES(27,'7305405b-ed57-476d-8256-1ecdd96a23f5','PULLEY_CHECK','Check pulley wheels','PULLEY_WHEEL',NULL,NULL,'PULLEY_INSPECT','INTERVAL',5000.0,NULL,NULL,NULL,NULL,'["PULLEY_INSPECT"]',300.0,NULL,'DEFAULT',1,'Common workshop practice, not a maker''s figure.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(28,'cf894753-d122-4b84-947c-0110b350892a','CHAINRING_CHECK','Check chainring wear','CHAINRING',NULL,NULL,'CHAINRING_INSPECT','INTERVAL',5000.0,NULL,NULL,NULL,NULL,'["CHAINRING_INSPECT"]',300.0,NULL,'DEFAULT',1,'Check at least at every chain change; common practice, not a maker''s figure.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(29,'968ca087-8b29-497e-b1b0-a1da544fe837','QUICK_LINK_CHAINS','Replace quick link','QUICK_LINK',NULL,NULL,'QUICK_LINK_CHECK','PARENT_COUNT',NULL,NULL,NULL,NULL,NULL,'["QUICK_LINK_CHECK"]',NULL,NULL,'DEFAULT',1,'Wippermann Connex links are sold as reusable many times; no official limit was found. Replace after 2 chains (your choice) or as soon as it closes noticeably looser than new.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,2,NULL);
INSERT INTO "service_rule" VALUES(30,'8b87e1e6-8cee-4d3f-b2cc-75d07fb76383','RIM_TAPE_CHECK','Check rim tape','RIM_TAPE',NULL,NULL,'RIM_TAPE_CHECK','INTERVAL',NULL,12,NULL,NULL,NULL,'["RIM_TAPE_CHECK"]',NULL,30,'DEFAULT',1,'Check at every tire change or yearly (tubes: tape covers the spoke holes; tubeless: it seals).','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(31,'0f9cce85-1d86-4615-afa1-4e38438e4911','HOSE_CHECK','Inspect brake hoses and caliper','BRAKE_CIRCUIT',NULL,NULL,'HOSE_INSPECT','INTERVAL',NULL,12,NULL,NULL,NULL,'["HOSE_INSPECT", "BRAKE_FLUID_REPLACE"]',NULL,30,'DEFAULT',1,'With every fluid change or yearly; personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(32,'752c58a2-44b2-4d5c-a8da-060145c3e8e3','PAD_BED_IN','Bed in new pads','BRAKE_PADS',NULL,NULL,'BED_IN','ONCE_AFTER_INSTALL',NULL,NULL,NULL,100.0,NULL,'["BED_IN"]',NULL,NULL,'DEFAULT',1,'Once after fitting; after 100 km without it the pads count as bedded in.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(33,'d8b8226b-3d17-474d-8d37-d16c7f565da0','ROTOR_BED_IN','Bed in new rotor','BRAKE_ROTOR',NULL,NULL,'BED_IN','ONCE_AFTER_INSTALL',NULL,NULL,NULL,100.0,NULL,'["BED_IN"]',NULL,NULL,'DEFAULT',1,'Once after fitting; after 100 km without it the rotor counts as bedded in.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(34,'619d1433-cd6e-47ba-8c2a-06ee60e4b7a1','PEDAL_BEARINGS','Service pedal bearings','PEDALS',NULL,NULL,'PEDAL_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["PEDAL_SERVICE"]',300.0,30,'DEFAULT',1,'Rider figure, not a maker''s interval.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(35,'10eb7b56-24eb-4988-88a3-6da743ac37f5','POWER_PEDAL_BEARINGS','Service pedal bearings','POWER_METER_PEDALS',NULL,NULL,'PEDAL_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["PEDAL_SERVICE"]',300.0,30,'DEFAULT',1,'No Favero interval found; riders regrease Assioma pedals about yearly or every 2,500 km.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(36,'2b972eb8-1636-412d-9ba7-5677cd5f6b43','BB_CHECK','Check bottom bracket','BOTTOM_BRACKET',NULL,NULL,'BB_INSPECT','INTERVAL',6000.0,12,NULL,NULL,NULL,'["BB_INSPECT"]',300.0,30,'DEFAULT',1,'Personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(37,'f441cd29-bbf4-46b1-94cb-0feeb336cf51','BAR_TAPE_CHECK','Inspect bar tape','BAR_TAPE',NULL,NULL,'BAR_TAPE_INSPECT','INTERVAL',NULL,12,NULL,NULL,NULL,'["BAR_TAPE_INSPECT", "BAR_TAPE_REWRAP"]',NULL,30,'DEFAULT',1,'Personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(38,'3fe069ad-f746-4d46-bde4-2e0351b8400c','SEATPOST_PASTE','Re-paste seatpost','SEATPOST',NULL,NULL,'SEATPOST_SERVICE','INTERVAL',NULL,12,NULL,NULL,NULL,'["SEATPOST_SERVICE"]',NULL,30,'DEFAULT',1,'Stops a seatpost from seizing; personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(39,'26815a15-4917-4bee-9c8a-a43436927f78','HANGER_CHECK','Check derailleur hanger','DERAILLEUR_HANGER',NULL,NULL,'HANGER_ALIGN','INTERVAL',NULL,12,NULL,NULL,NULL,'["HANGER_ALIGN"]',NULL,30,'DEFAULT',1,'Also after every crash; personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(40,'fe34afe9-84cb-4fb8-95f1-c1e861e5c067','CLEAT_CHECK','Inspect cleats','CLEATS',NULL,NULL,'CLEAT_INSPECT','INTERVAL',2000.0,NULL,NULL,NULL,NULL,'["CLEAT_INSPECT"]',200.0,NULL,'DEFAULT',1,'Replace when a wear pad is worn through or clipping feels different, often about 6,000 km (rider figure; BikeRadar).','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(41,'81c00654-b4e0-4d27-b553-f792ddf24f07','SHIFT_CABLE_CHECK','Check shift cable','SHIFT_CABLE',NULL,NULL,'CABLE_INSPECT','INTERVAL',5000.0,12,NULL,NULL,NULL,'["CABLE_INSPECT"]',300.0,30,'DEFAULT',1,'Personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','MECHANICAL',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(42,'906a4fbf-4368-4479-b279-879c1a39b664','SHIFT_HOUSING_CHECK','Check shift housing','SHIFT_HOUSING',NULL,NULL,'CABLE_INSPECT','INTERVAL',5000.0,12,NULL,NULL,NULL,'["CABLE_INSPECT"]',300.0,30,'DEFAULT',1,'Personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','MECHANICAL',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(43,'3b986bef-550b-440a-b7a3-447c33241835','BIKE_TORQUE_CHECK','Torque check','BIKE',NULL,NULL,'TORQUE_CHECK','INTERVAL',NULL,3,NULL,NULL,NULL,'["TORQUE_CHECK"]',NULL,14,'DEFAULT',1,'Every 3 months and once after the first ride on a newly fitted part (personal value). Torque values come from each product''s spec (torque_nm) where you entered it.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(44,'71c0cd5e-9636-4bbd-9bb8-84a111713249','BIKE_DI2_CHECK','Di2 check (firmware, errors)','BIKE',NULL,NULL,'DI2_SYSTEM_CHECK','INTERVAL',NULL,6,NULL,NULL,NULL,'["DI2_SYSTEM_CHECK"]',NULL,14,'DEFAULT',1,'Firmware is updated with Shimano E-TUBE; 6 months is a personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','ELECTRONIC',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(45,'a7fd603f-59b3-472e-ae68-462d559f1de2','BIKE_DI2_WIRES','Inspect Di2 wires','BIKE',NULL,NULL,'DI2_WIRE_INSPECT','INTERVAL',NULL,12,NULL,NULL,NULL,'["DI2_WIRE_INSPECT"]',NULL,30,'DEFAULT',1,'Personal value.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z','ELECTRONIC',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(46,'a5017397-f705-4b66-b0ab-ca7d3a7075dc','BIKE_FULL_SERVICE','Yearly full service','BIKE',NULL,NULL,'FULL_SERVICE','INTERVAL',NULL,12,NULL,NULL,NULL,'["FULL_SERVICE"]',NULL,30,'DEFAULT',1,'Once a year, a full service of the whole bike: Wheel hub bearings: play and roughness; Headset: clean, grease, check play; Bottom bracket: play and noise; Brakes: bleed (or check lever feel), hoses, pads, rotors; Di2 wires and junction / shift cables and housing; Frame and fork: cracks, dents, chips; Drivetrain: deep clean, chain, cassette and chainring wear; Pedals: bearing play; Torque check of all bolts. Personal value; each job keeps its own reminder.','2026-11-16T17:09:57Z','2026-11-16T17:09:57Z',NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO "usage_adjustment" VALUES(1,'a86edbe9-4d51-4b08-a33d-ae7eb45aed57',NULL,1,'STARTING','2026-08-19','2026-08-18T22:00:00Z',850.0,1,NULL,NULL,'2026-11-16T17:09:57Z');
INSERT INTO "usage_adjustment" VALUES(2,'ed441d83-4727-460a-bdff-c221de4c0459',1,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',850.0,1,'from Aurora SL''s starting km',NULL,'2026-11-16T17:09:57Z');
INSERT INTO "usage_adjustment" VALUES(3,'1e80313c-930e-4d96-89f5-e13862f0b0d7',NULL,2,'STARTING','2026-08-19','2026-08-18T22:00:00Z',4200.0,1,NULL,NULL,'2026-11-16T17:09:57Z');
INSERT INTO "usage_adjustment" VALUES(4,'09aa1cca-874e-4a0a-841d-552e653d481f',2,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',4200.0,1,'from Winter Allroad''s starting km',NULL,'2026-11-16T17:09:57Z');
INSERT INTO "usage_adjustment" VALUES(5,'5a8fc904-511c-4f86-ada3-2cf7f5b4fb51',4,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',1200.0,1,'bought used; seller''s estimate',NULL,'2026-11-16T17:09:57Z');
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
INSERT INTO "usage_profile" VALUES(1,'481cd2d6-17a7-400c-9079-32421055321b','OUTDOOR','Outdoor','OUTDOOR','[]','[]','');
INSERT INTO "usage_profile" VALUES(2,'4090ea76-ee82-43a6-9f35-c24fb63edcab','DIRECT_DRIVE_TRAINER','Direct-drive trainer (wheels off)','TRAINER','["WHEELSET", "FRONT_WHEEL", "REAR_WHEEL", "CASSETTE"]','["BRAKE_PADS", "TIRE", "BRAKE_ROTOR"]','Rear wheel and cassette are removed; the trainer has its own cassette. Front wheel, tires, rotors and pads do not wear.');
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
INSERT INTO "work_session" VALUES(1,'71722a23-0991-442d-b044-8b5ab0161b59','2026-08-19','2026-08-19',1,'Ultegra Di2 groupset',NULL,'2026-11-16T17:09:57Z',NULL,NULL);
INSERT INTO "work_session" VALUES(2,'49d0b5b8-4092-4460-a49b-ef1b3d156a40','2026-08-19','2026-08-19',2,'GRX 1×12 groupset',NULL,'2026-11-16T17:09:57Z',NULL,NULL);
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
CREATE INDEX ix_component_type_label ON component (component_type, label);
CREATE UNIQUE INDEX uq_rule_bike_code ON service_rule (bike_id, rule_code) WHERE bike_id IS NOT NULL;
CREATE UNIQUE INDEX uq_rule_component_code ON service_rule (component_id, rule_code) WHERE component_id IS NOT NULL;
CREATE UNIQUE INDEX uq_rule_type_code ON service_rule (component_type, rule_code) WHERE component_type IS NOT NULL;
CREATE TRIGGER trg_service_rule_requires_setup_insert BEFORE INSERT ON service_rule
        FOR EACH ROW WHEN NEW.requires_setup IS NOT NULL AND NEW.requires_setup NOT IN ('TUBE','TUBELESS','TUBULAR','ELECTRONIC','MECHANICAL')
        BEGIN SELECT RAISE(ABORT, 'INVALID: service_rule.requires_setup must be TUBE, TUBELESS, TUBULAR, ELECTRONIC or MECHANICAL'); END;
CREATE TRIGGER trg_service_rule_requires_setup_update BEFORE UPDATE ON service_rule
        FOR EACH ROW WHEN NEW.requires_setup IS NOT NULL AND NEW.requires_setup NOT IN ('TUBE','TUBELESS','TUBULAR','ELECTRONIC','MECHANICAL')
        BEGIN SELECT RAISE(ABORT, 'INVALID: service_rule.requires_setup must be TUBE, TUBELESS, TUBULAR, ELECTRONIC or MECHANICAL'); END;
COMMIT;
