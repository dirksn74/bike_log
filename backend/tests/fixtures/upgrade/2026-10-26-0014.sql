-- Bike Log 2026-10-26-0014 (schema revision 0014), demo/sample data made by that version's own code.
BEGIN TRANSACTION;
CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL, 
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);
INSERT INTO "alembic_version" VALUES('0014');
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
	updated_at VARCHAR(20) NOT NULL, purchase_price_cents INTEGER, purchase_date VARCHAR(10), shifting VARCHAR(12), 
	PRIMARY KEY (id), 
	CONSTRAINT ck_bike_status CHECK (status IN ('ACTIVE','RETIRED')), 
	UNIQUE (name), 
	UNIQUE (strava_gear_id), 
	UNIQUE (uuid)
);
INSERT INTO "bike" VALUES(1,'06175be8-3557-49f8-97be-23f93edc9e72','Aurora SL','Sample','Aurora SL',2026,'ACTIVE',NULL,'Sample data (made up). Settings → Fresh start removes it.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',249900,'2026-02-27',NULL);
INSERT INTO "bike" VALUES(2,'a18dba7f-d30f-4f4b-bce5-759988135e43','Winter Allroad','Sample','Allroad',2023,'ACTIVE',NULL,'Sample data (made up). Settings → Fresh start removes it.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,'MECHANICAL');
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
INSERT INTO "change_log" VALUES(1,'2026-11-14T18:52:47Z',1,NULL,'CREATED',NULL,NULL,'Aurora SL','SAMPLE','demo');
INSERT INTO "change_log" VALUES(2,'2026-11-14T18:52:47Z',NULL,1,'CREATED',NULL,NULL,'Frame Aurora SL frame','SAMPLE','demo');
INSERT INTO "change_log" VALUES(3,'2026-11-14T18:52:47Z',1,1,'INSTALLED',NULL,NULL,'Aurora SL (frame) from 2026-02-27','SAMPLE','demo');
INSERT INTO "change_log" VALUES(4,'2026-11-14T18:52:47Z',NULL,2,'CREATED',NULL,NULL,'Fork Aurora SL fork','SAMPLE','demo');
INSERT INTO "change_log" VALUES(5,'2026-11-14T18:52:47Z',1,2,'INSTALLED',NULL,NULL,'Aurora SL (fork) from 2026-02-27','SAMPLE','demo');
INSERT INTO "change_log" VALUES(6,'2026-11-14T18:52:47Z',2,NULL,'CREATED',NULL,NULL,'Winter Allroad','SAMPLE','demo');
INSERT INTO "change_log" VALUES(7,'2026-11-14T18:52:47Z',NULL,3,'CREATED',NULL,NULL,'Frame Winter Allroad frame','SAMPLE','demo');
INSERT INTO "change_log" VALUES(8,'2026-11-14T18:52:47Z',2,3,'INSTALLED',NULL,NULL,'Winter Allroad (frame) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(9,'2026-11-14T18:52:47Z',NULL,4,'CREATED',NULL,NULL,'Fork Winter Allroad fork','SAMPLE','demo');
INSERT INTO "change_log" VALUES(10,'2026-11-14T18:52:47Z',2,4,'INSTALLED',NULL,NULL,'Winter Allroad (fork) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(11,'2026-11-14T18:52:47Z',NULL,5,'CREATED',NULL,NULL,'Front wheel DT Swiss ARC 1400 front (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(12,'2026-11-14T18:52:47Z',NULL,6,'CREATED',NULL,NULL,'Rear wheel DT Swiss ARC 1400 rear (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(13,'2026-11-14T18:52:47Z',NULL,6,'CHANGED','history before tracking','unknown','recorded','SAMPLE','demo');
INSERT INTO "change_log" VALUES(14,'2026-11-14T18:52:47Z',1,5,'INSTALLED',NULL,NULL,'Aurora SL (front wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(15,'2026-11-14T18:52:47Z',NULL,7,'CREATED',NULL,NULL,'Tire GP5000 32 mm front (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(16,'2026-11-14T18:52:47Z',NULL,7,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 front (Aurora SL) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(17,'2026-11-14T18:52:47Z',NULL,8,'CREATED',NULL,NULL,'Inner tube tube front (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(18,'2026-11-14T18:52:47Z',NULL,8,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 front (Aurora SL) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(19,'2026-11-14T18:52:47Z',1,6,'INSTALLED',NULL,NULL,'Aurora SL (rear wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(20,'2026-11-14T18:52:47Z',NULL,9,'CREATED',NULL,NULL,'Tire GP5000 32 mm rear (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(21,'2026-11-14T18:52:47Z',NULL,9,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(22,'2026-11-14T18:52:47Z',NULL,10,'CREATED',NULL,NULL,'Inner tube tube rear (Aurora SL)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(23,'2026-11-14T18:52:47Z',NULL,10,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(24,'2026-11-14T18:52:47Z',NULL,11,'CREATED',NULL,NULL,'Front wheel Alloy front (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(25,'2026-11-14T18:52:47Z',NULL,12,'CREATED',NULL,NULL,'Rear wheel Alloy rear (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(26,'2026-11-14T18:52:47Z',2,11,'INSTALLED',NULL,NULL,'Winter Allroad (front wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(27,'2026-11-14T18:52:47Z',NULL,13,'CREATED',NULL,NULL,'Tire GP5000 32 mm front (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(28,'2026-11-14T18:52:47Z',NULL,13,'INSTALLED',NULL,NULL,'Alloy front (Winter Allroad) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(29,'2026-11-14T18:52:47Z',NULL,14,'CREATED',NULL,NULL,'Inner tube tube front (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(30,'2026-11-14T18:52:47Z',NULL,14,'INSTALLED',NULL,NULL,'Alloy front (Winter Allroad) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(31,'2026-11-14T18:52:47Z',2,12,'INSTALLED',NULL,NULL,'Winter Allroad (rear wheel) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(32,'2026-11-14T18:52:47Z',NULL,15,'CREATED',NULL,NULL,'Tire GP5000 32 mm rear (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(33,'2026-11-14T18:52:47Z',NULL,15,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (tire) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(34,'2026-11-14T18:52:47Z',NULL,16,'CREATED',NULL,NULL,'Inner tube tube rear (Winter Allroad)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(35,'2026-11-14T18:52:47Z',NULL,16,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (tube) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(36,'2026-11-14T18:52:47Z',NULL,17,'CREATED',NULL,NULL,'Wheelset DT Swiss ARC 1400 wheelset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(37,'2026-11-14T18:52:47Z',1,5,'REMOVED',NULL,'Aurora SL (front wheel)','on 2026-08-20 · moved','SAMPLE','demo');
INSERT INTO "change_log" VALUES(38,'2026-11-14T18:52:47Z',1,6,'REMOVED',NULL,'Aurora SL (rear wheel)','on 2026-08-20 · moved','SAMPLE','demo');
INSERT INTO "change_log" VALUES(39,'2026-11-14T18:52:47Z',1,17,'INSTALLED',NULL,NULL,'Aurora SL (wheelset) from 2026-08-20','SAMPLE','demo');
INSERT INTO "change_log" VALUES(40,'2026-11-14T18:52:47Z',NULL,5,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 wheelset (front wheel) from 2026-08-20','SAMPLE','demo');
INSERT INTO "change_log" VALUES(41,'2026-11-14T18:52:47Z',NULL,6,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 wheelset (rear wheel) from 2026-08-20','SAMPLE','demo');
INSERT INTO "change_log" VALUES(42,'2026-11-14T18:52:47Z',NULL,18,'CREATED',NULL,NULL,'Shifters Ultegra Di2 levers','SAMPLE','demo');
INSERT INTO "change_log" VALUES(43,'2026-11-14T18:52:47Z',1,18,'INSTALLED',NULL,NULL,'Aurora SL (shifters) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(44,'2026-11-14T18:52:47Z',NULL,19,'CREATED',NULL,NULL,'Front derailleur Ultegra front derailleur','SAMPLE','demo');
INSERT INTO "change_log" VALUES(45,'2026-11-14T18:52:47Z',1,19,'INSTALLED',NULL,NULL,'Aurora SL (front derailleur) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(46,'2026-11-14T18:52:47Z',NULL,20,'CREATED',NULL,NULL,'Rear derailleur Ultegra rear derailleur','SAMPLE','demo');
INSERT INTO "change_log" VALUES(47,'2026-11-14T18:52:47Z',1,20,'INSTALLED',NULL,NULL,'Aurora SL (rear derailleur) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(48,'2026-11-14T18:52:47Z',NULL,21,'CREATED',NULL,NULL,'Pulley wheel Ultegra upper pulley (guide)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(49,'2026-11-14T18:52:47Z',NULL,21,'INSTALLED',NULL,NULL,'Ultegra rear derailleur (pulley upper) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(50,'2026-11-14T18:52:47Z',NULL,22,'CREATED',NULL,NULL,'Pulley wheel Ultegra lower pulley (tension)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(51,'2026-11-14T18:52:47Z',NULL,22,'INSTALLED',NULL,NULL,'Ultegra rear derailleur (pulley lower) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(52,'2026-11-14T18:52:47Z',NULL,23,'CREATED',NULL,NULL,'Crankset Ultegra crankset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(53,'2026-11-14T18:52:47Z',1,23,'INSTALLED',NULL,NULL,'Aurora SL (crankset) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(54,'2026-11-14T18:52:47Z',NULL,24,'CREATED',NULL,NULL,'Chainring Ultegra outer chainring 52T','SAMPLE','demo');
INSERT INTO "change_log" VALUES(55,'2026-11-14T18:52:47Z',NULL,24,'INSTALLED',NULL,NULL,'Ultegra crankset (chainring outer) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(56,'2026-11-14T18:52:47Z',NULL,25,'CREATED',NULL,NULL,'Chainring Ultegra inner chainring 36T','SAMPLE','demo');
INSERT INTO "change_log" VALUES(57,'2026-11-14T18:52:47Z',NULL,25,'INSTALLED',NULL,NULL,'Ultegra crankset (chainring inner) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(58,'2026-11-14T18:52:47Z',NULL,26,'CREATED',NULL,NULL,'Bottom bracket Ultegra bottom bracket','SAMPLE','demo');
INSERT INTO "change_log" VALUES(59,'2026-11-14T18:52:47Z',1,26,'INSTALLED',NULL,NULL,'Aurora SL (bottom bracket) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(60,'2026-11-14T18:52:47Z',NULL,27,'CREATED',NULL,NULL,'Cassette Ultegra cassette 11-34','SAMPLE','demo');
INSERT INTO "change_log" VALUES(61,'2026-11-14T18:52:47Z',NULL,27,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (cassette) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(62,'2026-11-14T18:52:47Z',NULL,28,'CREATED',NULL,NULL,'Chain Ultegra chain','SAMPLE','demo');
INSERT INTO "change_log" VALUES(63,'2026-11-14T18:52:47Z',1,28,'INSTALLED',NULL,NULL,'Aurora SL (chain) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(64,'2026-11-14T18:52:47Z',NULL,28,'CHANGED','chain rotation of bike',NULL,'1','SAMPLE','demo');
INSERT INTO "change_log" VALUES(65,'2026-11-14T18:52:47Z',NULL,29,'CREATED',NULL,NULL,'Quick link Ultegra quick link','SAMPLE','demo');
INSERT INTO "change_log" VALUES(66,'2026-11-14T18:52:47Z',NULL,29,'INSTALLED',NULL,NULL,'Ultegra chain (quick link) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(67,'2026-11-14T18:52:47Z',NULL,30,'CREATED',NULL,NULL,'Brake circuit (hydraulic) Ultegra front brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(68,'2026-11-14T18:52:47Z',1,30,'INSTALLED',NULL,NULL,'Aurora SL (front brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(69,'2026-11-14T18:52:47Z',NULL,31,'CREATED',NULL,NULL,'Brake circuit (hydraulic) Ultegra rear brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(70,'2026-11-14T18:52:47Z',1,31,'INSTALLED',NULL,NULL,'Aurora SL (rear brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(71,'2026-11-14T18:52:47Z',NULL,32,'CREATED',NULL,NULL,'Brake pads Ultegra front pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(72,'2026-11-14T18:52:47Z',1,32,'INSTALLED',NULL,NULL,'Aurora SL (front pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(73,'2026-11-14T18:52:47Z',NULL,33,'CREATED',NULL,NULL,'Brake pads Ultegra rear pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(74,'2026-11-14T18:52:47Z',1,33,'INSTALLED',NULL,NULL,'Aurora SL (rear pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(75,'2026-11-14T18:52:47Z',NULL,34,'CREATED',NULL,NULL,'Brake rotor Ultegra front rotor 160 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(76,'2026-11-14T18:52:47Z',NULL,34,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 front (Aurora SL) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(77,'2026-11-14T18:52:47Z',NULL,35,'CREATED',NULL,NULL,'Brake rotor Ultegra rear rotor 140 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(78,'2026-11-14T18:52:47Z',NULL,35,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(79,'2026-11-14T18:52:47Z',NULL,36,'CREATED',NULL,NULL,'Battery (Di2/AXS) Ultegra Di2 battery','SAMPLE','demo');
INSERT INTO "change_log" VALUES(80,'2026-11-14T18:52:47Z',1,36,'INSTALLED',NULL,NULL,'Aurora SL (battery) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(81,'2026-11-14T18:52:48Z',NULL,33,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(82,'2026-11-14T18:52:48Z',NULL,24,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(83,'2026-11-14T18:52:48Z',NULL,32,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(84,'2026-11-14T18:52:48Z',NULL,19,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(85,'2026-11-14T18:52:48Z',NULL,25,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(86,'2026-11-14T18:52:48Z',NULL,31,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(87,'2026-11-14T18:52:48Z',NULL,20,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(88,'2026-11-14T18:52:48Z',NULL,35,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(89,'2026-11-14T18:52:48Z',NULL,26,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(90,'2026-11-14T18:52:48Z',NULL,30,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(91,'2026-11-14T18:52:48Z',NULL,21,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(92,'2026-11-14T18:52:48Z',NULL,36,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(93,'2026-11-14T18:52:48Z',NULL,27,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(94,'2026-11-14T18:52:48Z',NULL,29,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(95,'2026-11-14T18:52:48Z',NULL,34,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(96,'2026-11-14T18:52:48Z',NULL,22,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(97,'2026-11-14T18:52:48Z',NULL,28,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(98,'2026-11-14T18:52:48Z',NULL,23,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(99,'2026-11-14T18:52:48Z',NULL,18,'CHANGED','bought in bundle',NULL,'Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(100,'2026-11-14T18:52:48Z',NULL,37,'CREATED',NULL,NULL,'Shifters GRX levers','SAMPLE','demo');
INSERT INTO "change_log" VALUES(101,'2026-11-14T18:52:48Z',2,37,'INSTALLED',NULL,NULL,'Winter Allroad (shifters) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(102,'2026-11-14T18:52:48Z',NULL,38,'CREATED',NULL,NULL,'Rear derailleur GRX rear derailleur','SAMPLE','demo');
INSERT INTO "change_log" VALUES(103,'2026-11-14T18:52:48Z',2,38,'INSTALLED',NULL,NULL,'Winter Allroad (rear derailleur) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(104,'2026-11-14T18:52:48Z',NULL,39,'CREATED',NULL,NULL,'Pulley wheel GRX upper pulley (guide)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(105,'2026-11-14T18:52:48Z',NULL,39,'INSTALLED',NULL,NULL,'GRX rear derailleur (pulley upper) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(106,'2026-11-14T18:52:48Z',NULL,40,'CREATED',NULL,NULL,'Pulley wheel GRX lower pulley (tension)','SAMPLE','demo');
INSERT INTO "change_log" VALUES(107,'2026-11-14T18:52:48Z',NULL,40,'INSTALLED',NULL,NULL,'GRX rear derailleur (pulley lower) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(108,'2026-11-14T18:52:48Z',NULL,41,'CREATED',NULL,NULL,'Crankset GRX crankset','SAMPLE','demo');
INSERT INTO "change_log" VALUES(109,'2026-11-14T18:52:48Z',2,41,'INSTALLED',NULL,NULL,'Winter Allroad (crankset) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(110,'2026-11-14T18:52:48Z',NULL,42,'CREATED',NULL,NULL,'Chainring GRX chainring 40T','SAMPLE','demo');
INSERT INTO "change_log" VALUES(111,'2026-11-14T18:52:48Z',NULL,42,'INSTALLED',NULL,NULL,'GRX crankset (chainring outer) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(112,'2026-11-14T18:52:48Z',NULL,43,'CREATED',NULL,NULL,'Bottom bracket GRX bottom bracket','SAMPLE','demo');
INSERT INTO "change_log" VALUES(113,'2026-11-14T18:52:48Z',2,43,'INSTALLED',NULL,NULL,'Winter Allroad (bottom bracket) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(114,'2026-11-14T18:52:48Z',NULL,44,'CREATED',NULL,NULL,'Cassette GRX cassette 10-45','SAMPLE','demo');
INSERT INTO "change_log" VALUES(115,'2026-11-14T18:52:48Z',NULL,44,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (cassette) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(116,'2026-11-14T18:52:48Z',NULL,45,'CREATED',NULL,NULL,'Chain GRX chain','SAMPLE','demo');
INSERT INTO "change_log" VALUES(117,'2026-11-14T18:52:48Z',2,45,'INSTALLED',NULL,NULL,'Winter Allroad (chain) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(118,'2026-11-14T18:52:48Z',NULL,45,'CHANGED','chain rotation of bike',NULL,'2','SAMPLE','demo');
INSERT INTO "change_log" VALUES(119,'2026-11-14T18:52:48Z',NULL,46,'CREATED',NULL,NULL,'Quick link GRX quick link','SAMPLE','demo');
INSERT INTO "change_log" VALUES(120,'2026-11-14T18:52:48Z',NULL,46,'INSTALLED',NULL,NULL,'GRX chain (quick link) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(121,'2026-11-14T18:52:48Z',NULL,47,'CREATED',NULL,NULL,'Brake circuit (hydraulic) GRX front brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(122,'2026-11-14T18:52:48Z',2,47,'INSTALLED',NULL,NULL,'Winter Allroad (front brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(123,'2026-11-14T18:52:48Z',NULL,48,'CREATED',NULL,NULL,'Brake circuit (hydraulic) GRX rear brake','SAMPLE','demo');
INSERT INTO "change_log" VALUES(124,'2026-11-14T18:52:48Z',2,48,'INSTALLED',NULL,NULL,'Winter Allroad (rear brake) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(125,'2026-11-14T18:52:48Z',NULL,49,'CREATED',NULL,NULL,'Brake pads GRX front pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(126,'2026-11-14T18:52:48Z',2,49,'INSTALLED',NULL,NULL,'Winter Allroad (front pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(127,'2026-11-14T18:52:48Z',NULL,50,'CREATED',NULL,NULL,'Brake pads GRX rear pads','SAMPLE','demo');
INSERT INTO "change_log" VALUES(128,'2026-11-14T18:52:48Z',2,50,'INSTALLED',NULL,NULL,'Winter Allroad (rear pads) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(129,'2026-11-14T18:52:48Z',NULL,51,'CREATED',NULL,NULL,'Brake rotor GRX front rotor 160 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(130,'2026-11-14T18:52:48Z',NULL,51,'INSTALLED',NULL,NULL,'Alloy front (Winter Allroad) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(131,'2026-11-14T18:52:48Z',NULL,52,'CREATED',NULL,NULL,'Brake rotor GRX rear rotor 160 mm','SAMPLE','demo');
INSERT INTO "change_log" VALUES(132,'2026-11-14T18:52:48Z',NULL,52,'INSTALLED',NULL,NULL,'Alloy rear (Winter Allroad) (rotor) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(133,'2026-11-14T18:52:48Z',NULL,53,'CREATED',NULL,NULL,'Shift cable GRX rear shift cable','SAMPLE','demo');
INSERT INTO "change_log" VALUES(134,'2026-11-14T18:52:48Z',2,53,'INSTALLED',NULL,NULL,'Winter Allroad (shift cable rear) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(135,'2026-11-14T18:52:48Z',NULL,54,'CREATED',NULL,NULL,'Shift housing GRX rear shift housing','SAMPLE','demo');
INSERT INTO "change_log" VALUES(136,'2026-11-14T18:52:48Z',2,54,'INSTALLED',NULL,NULL,'Winter Allroad (shift housing rear) from 2026-08-19','SAMPLE','demo');
INSERT INTO "change_log" VALUES(137,'2026-11-14T18:52:48Z',NULL,55,'CREATED',NULL,NULL,'Inner tube Inner tube Road tube 700×28-32 #1','SAMPLE','demo');
INSERT INTO "change_log" VALUES(138,'2026-11-14T18:52:48Z',NULL,10,'REMOVED',NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tube)','on 2026-08-22T10:00:00Z · Awaiting inspection or repair','SAMPLE','demo');
INSERT INTO "change_log" VALUES(139,'2026-11-14T18:52:48Z',NULL,10,'CHANGED','state when not installed','Stored as a reusable spare','Awaiting inspection or repair','SAMPLE','demo');
INSERT INTO "change_log" VALUES(140,'2026-11-14T18:52:48Z',NULL,55,'INSTALLED',NULL,NULL,'DT Swiss ARC 1400 rear (Aurora SL) (tube) from 2026-08-22T10:00:00Z','SAMPLE','demo');
CREATE TABLE component (
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
	updated_at VARCHAR(20) NOT NULL, specs_json TEXT DEFAULT '{}' NOT NULL, disposition VARCHAR(20) DEFAULT 'STORED' NOT NULL, disposition_on VARCHAR(10), purchase_session_id INTEGER, from_stock_txn_id INTEGER, storage_location TEXT, tire_setup VARCHAR(12), bundle_id INTEGER REFERENCES purchase_bundle (id), pressure_note TEXT, mark TEXT, rotation_bike_id INTEGER REFERENCES bike (id), warranty_until VARCHAR(10), 
	PRIMARY KEY (id), 
	CONSTRAINT ck_component_prior_usage CHECK (prior_usage IN ('NEW','RECORDED','UNKNOWN')), 
	CONSTRAINT ck_component_status CHECK (status IN ('ACTIVE','RETIRED')), 
	FOREIGN KEY(product_id) REFERENCES product (id), 
	CONSTRAINT uq_component_type_label UNIQUE (component_type, label), 
	UNIQUE (uuid)
);
INSERT INTO "component" VALUES(1,'9a42bf56-b14a-413d-aa2d-5ad92d609f93','FRAME','Aurora SL frame',NULL,NULL,'RECORDED',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(2,'07a6f326-68ec-4659-9b8b-ec8f77268961','FORK','Aurora SL fork',NULL,NULL,'RECORDED',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(3,'70513a18-3b08-430c-bb53-ebce4c891903','FRAME','Winter Allroad frame',NULL,NULL,'RECORDED',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(4,'0a592585-3a35-4523-8104-755b4145be74','FORK','Winter Allroad fork',NULL,NULL,'RECORDED',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(5,'b7434801-83f1-4829-a1b7-b6561ad72078','FRONT_WHEEL','DT Swiss ARC 1400 front (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(6,'2a71a5ce-6c79-4c2c-8890-37172c7804ad','REAR_WHEEL','DT Swiss ARC 1400 rear (Aurora SL)',NULL,NULL,'RECORDED','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(7,'ae8f1c8a-e170-446a-9707-0ed628ac9fc4','TIRE','GP5000 32 mm front (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(8,'2ed5f19d-48e7-42d2-ac65-bf5694f451d7','INNER_TUBE','tube front (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(9,'e3587df9-f569-4ea9-b066-2b2e33a8b3e4','TIRE','GP5000 32 mm rear (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(10,'dbe49a99-7a1d-4377-a3f1-8642756e891b','INNER_TUBE','tube rear (Aurora SL)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','AWAITING_SERVICE','2026-08-22',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(11,'9d874816-cac1-4b06-9a2b-4f564723d48c','FRONT_WHEEL','Alloy front (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(12,'436dd6cb-9def-487c-847c-2e0d045ff50f','REAR_WHEEL','Alloy rear (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,'TUBE',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(13,'9f972a79-721b-4d83-aadf-83f5b6d2cdcb','TIRE','GP5000 32 mm front (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(14,'2b2f74a4-dad4-4a88-a789-3d4080c44233','INNER_TUBE','tube front (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(15,'88495b42-07a4-4fce-89d8-41a6da91b98f','TIRE','GP5000 32 mm rear (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(16,'2144273b-0440-4e3d-852b-0af5c28db4fe','INNER_TUBE','tube rear (Winter Allroad)',NULL,NULL,'NEW','2026-08-11',NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(17,'74f2901c-0f7f-4b39-9dee-475caf4cafee','WHEELSET','DT Swiss ARC 1400 wheelset',NULL,NULL,'NEW',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','{}','STORED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(18,'e97ed937-95dc-4e2d-8707-63db9a4ecf58','SHIFTERS','Ultegra Di2 levers',1,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(19,'5975b730-1fdb-4867-baad-38d5397ea02f','FRONT_DERAILLEUR','Ultegra front derailleur',2,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(20,'95e376c9-9042-4f0e-975b-7b031b9bef5b','REAR_DERAILLEUR','Ultegra rear derailleur',3,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(21,'637dcc62-f4b8-4fbf-b463-2ade6aaf8d49','PULLEY_WHEEL','Ultegra upper pulley (guide)',4,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(22,'1fc218da-edc9-420a-a7ab-04ea4303b40f','PULLEY_WHEEL','Ultegra lower pulley (tension)',5,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(23,'d8c875d7-d3a3-44dd-b6d3-32e7986bd8f0','CRANKSET','Ultegra crankset',6,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(24,'594af712-6e1a-409f-9661-068612bb9e4d','CHAINRING','Ultegra outer chainring 52T',7,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(25,'d9deb97b-e933-40a2-bdd4-72525aeab652','CHAINRING','Ultegra inner chainring 36T',8,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(26,'c2a9df34-4371-4c09-ab08-4557cba5ff7d','BOTTOM_BRACKET','Ultegra bottom bracket',9,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(27,'6960fdcd-9545-4d2f-934e-f50dde08cf08','CASSETTE','Ultegra cassette 11-34',10,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(28,'2a81ff55-cc3f-4947-ab6f-8558ee31c575','CHAIN','Ultegra chain',11,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,1,NULL);
INSERT INTO "component" VALUES(29,'a1f922ec-b8cd-461d-a629-5d8d5b63a2ed','QUICK_LINK','Ultegra quick link',12,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(30,'5e23c071-289a-4cc7-8bad-ac5fb99bef2a','BRAKE_CIRCUIT','Ultegra front brake',13,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(31,'c79488dc-5149-4a14-b04e-299efe9b5018','BRAKE_CIRCUIT','Ultegra rear brake',14,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(32,'5863a15a-783a-414c-bb2b-78dd4baab278','BRAKE_PADS','Ultegra front pads',15,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(33,'83cdb597-8631-47be-8f09-6bb9ca184673','BRAKE_PADS','Ultegra rear pads',15,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(34,'5f0f551e-032c-499b-b685-73294be4875f','BRAKE_ROTOR','Ultegra front rotor 160 mm',16,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(35,'6fbf6821-46c1-48c5-b0c2-a8629618b762','BRAKE_ROTOR','Ultegra rear rotor 140 mm',17,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(36,'73df954e-82ed-4192-a7fa-7869dab8bdf1','BATTERY','Ultegra Di2 battery',18,NULL,'NEW','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc','2026-11-14T18:52:47Z','2026-11-14T18:52:48Z','{}','STORED',NULL,1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(37,'7d0bba2e-88ae-4910-a006-a3d523c37740','SHIFTERS','GRX levers',19,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(38,'ef14725d-8f3d-43ce-b7a8-f5ba48ff8364','REAR_DERAILLEUR','GRX rear derailleur',20,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(39,'2c67827a-29d7-4c18-8886-5e894b56e77e','PULLEY_WHEEL','GRX upper pulley (guide)',21,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(40,'4f0159dc-77e0-4ecb-91ef-851ed86d44dd','PULLEY_WHEEL','GRX lower pulley (tension)',22,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(41,'c7cdb2e7-6b62-49b4-91a0-4e39c8314e43','CRANKSET','GRX crankset',23,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(42,'d8aaac57-61ea-4994-9541-22ee52fdca33','CHAINRING','GRX chainring 40T',24,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(43,'b23f6260-9d54-4a65-a112-f728e74f6eb4','BOTTOM_BRACKET','GRX bottom bracket',9,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(44,'208f7c07-04ce-4067-b23a-434e6f7c9a99','CASSETTE','GRX cassette 10-45',25,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(45,'e3c3a929-5842-4a0f-82ec-026d7524e210','CHAIN','GRX chain',11,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,2,NULL);
INSERT INTO "component" VALUES(46,'663313f4-7ac3-48e8-9cd3-a97c28412085','QUICK_LINK','GRX quick link',12,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(47,'69bbf70a-58e8-4274-b3bc-54d06c8d7206','BRAKE_CIRCUIT','GRX front brake',26,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(48,'e6a0dfb0-0c6d-4212-8b66-1a3245db8ba3','BRAKE_CIRCUIT','GRX rear brake',27,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(49,'eb0a846d-aef6-4b0f-b907-b2a88d6b9397','BRAKE_PADS','GRX front pads',15,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(50,'49d3a913-555b-4703-b565-e49ac8a9c075','BRAKE_PADS','GRX rear pads',15,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(51,'b56dd25f-967c-44e6-9865-6cb417dfe001','BRAKE_ROTOR','GRX front rotor 160 mm',28,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(52,'d4e45e85-102c-4643-9540-82cea38304d5','BRAKE_ROTOR','GRX rear rotor 160 mm',28,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(53,'f8dbe5f4-ab06-4d0a-bc6a-8a7ca2959d0b','SHIFT_CABLE','GRX rear shift cable',29,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(54,'58bf8c9f-27e5-4cf2-b788-f7b4db9d26d1','SHIFT_HOUSING','GRX rear shift housing',30,NULL,'UNKNOWN','2026-08-19',NULL,'ACTIVE',NULL,NULL,'Added with the groupset import: Shimano GRX RX820 mechanical · 1×12 · hydraulic disc','2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "component" VALUES(55,'8a568964-c962-4b1c-8557-d0d565e2cd59','INNER_TUBE','Inner tube Road tube 700×28-32 #1',31,NULL,'NEW',NULL,NULL,'ACTIVE',NULL,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','{}','STORED',NULL,NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO "component_disposition" VALUES(1,10,'AWAITING_SERVICE','STORED','2026-08-22','pinch flat',NULL,'2026-11-14T18:52:48Z',NULL);
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
INSERT INTO "consumable" VALUES(1,'a93cdb6e-d2df-43b0-9635-e9fee4be974d','WAX','Hot wax (sample)',NULL,'g',1,NULL,'2026-11-14T18:52:48Z','BULK',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable" VALUES(2,'04e76d13-2d08-4919-822c-d5d1b817df98','WAX','Wax drip (sample)',NULL,'ml',0,NULL,'2026-11-14T18:52:48Z','BULK',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "consumable" VALUES(3,'fedb42f2-9b5a-430f-be71-043fb4313ab1','PART','Inner tube — Sample Road tube 700×28-32',NULL,'tube',1,NULL,'2026-11-14T18:52:48Z','COUNTED',NULL,'INNER_TUBE',31,'one tube','Garage shelf',2.0);
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
	voided_at VARCHAR(20), 
	PRIMARY KEY (id), 
	CONSTRAINT ck_consumable_txn_kind CHECK (kind IN ('PURCHASE','USE','RETURN','ADJUST')), 
	FOREIGN KEY(consumable_id) REFERENCES consumable (id), 
	FOREIGN KEY(maintenance_event_id) REFERENCES maintenance_event (id)
);
INSERT INTO "consumable_txn" VALUES(1,1,'PURCHASE',500.0,'2026-08-16',NULL,3999,NULL,'2026-11-14T18:52:48Z',NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(2,3,'PURCHASE',3.0,'2026-08-16',NULL,2097,NULL,'2026-11-14T18:52:48Z',NULL,NULL,3,NULL);
INSERT INTO "consumable_txn" VALUES(3,1,'USE',30.0,'2026-08-19',1,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(4,2,'USE',NULL,'2026-09-05',4,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(5,1,'USE',30.0,'2026-09-20',5,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,NULL,NULL);
INSERT INTO "consumable_txn" VALUES(6,3,'USE',1.0,'2026-08-22',NULL,NULL,'taken from stock to install','2026-11-14T18:52:48Z',NULL,55,NULL,NULL);
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
INSERT INTO "installation" VALUES(1,'95596de7-42fe-4a21-b381-d5a0f2f4352c',1,1,NULL,'FRAME','2026-02-27','2026-02-26T23:00:00Z',NULL,NULL,NULL,'Added with the bike (frame and fork are parts)',NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(2,'d9a728dc-0399-4241-a277-cd10f9dbbfd8',2,1,NULL,'FORK','2026-02-27','2026-02-26T23:00:00Z',NULL,NULL,NULL,'Added with the bike (frame and fork are parts)',NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(3,'e7cbb679-4a0e-4015-8209-aed58bfc2898',3,2,NULL,'FRAME','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,'Added with the bike (frame and fork are parts)',NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(4,'9f45af1f-3d7c-4112-bec9-36df6c7dc10b',4,2,NULL,'FORK','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,'Added with the bike (frame and fork are parts)',NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(5,'5c08570e-2fde-4718-ae56-3f7513447530',5,1,NULL,'FRONT_WHEEL','2026-08-19','2026-08-18T22:00:00Z','2026-08-20','2026-08-19T22:00:00Z','put into a wheelset',NULL,NULL,NULL,'2026-11-14T18:52:47Z','MOVED',NULL,NULL,NULL);
INSERT INTO "installation" VALUES(6,'315e4dde-0f72-4ca4-ad96-0ca5d8f1db8b',7,NULL,5,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(7,'0bd85ff2-7133-4233-bf2a-b686ff82da97',8,NULL,5,'TUBE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(8,'f9a42d45-1bfb-43b9-aee7-3e76d27c1a0e',6,1,NULL,'REAR_WHEEL','2026-08-19','2026-08-18T22:00:00Z','2026-08-20','2026-08-19T22:00:00Z','put into a wheelset',NULL,NULL,NULL,'2026-11-14T18:52:47Z','MOVED',NULL,NULL,NULL);
INSERT INTO "installation" VALUES(9,'fa85eb65-16c8-4836-bc4e-cad4d8f73ba1',9,NULL,6,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(10,'73525c43-d728-446e-8e4d-93b8e9eca5a5',10,NULL,6,'TUBE','2026-08-19','2026-08-18T22:00:00Z','2026-08-22T10:00:00Z','2026-08-22T10:00:00Z','pinch flat',NULL,NULL,NULL,'2026-11-14T18:52:47Z','AWAITING_SERVICE',NULL,NULL,NULL);
INSERT INTO "installation" VALUES(11,'3ecb6ff0-f3c8-4c55-9a90-5c4860a8c8e2',11,2,NULL,'FRONT_WHEEL','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(12,'e1d16342-0a45-4e18-9c28-049acb6519bd',13,NULL,11,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(13,'81f60431-3061-4abc-a2d9-3bdfa365a41b',14,NULL,11,'TUBE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(14,'9dd26231-b53f-4f37-9e23-375039af736c',12,2,NULL,'REAR_WHEEL','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(15,'4437d706-ecd3-4488-ab2c-944b681b82c2',15,NULL,12,'TIRE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(16,'910ebe47-81c8-45a5-b68d-984b3a3bf12d',16,NULL,12,'TUBE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(17,'3017cd9c-2488-4ccd-b9a6-4dd1c34ce750',17,1,NULL,'WHEELSET','2026-08-20','2026-08-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(18,'337bf354-37d7-4e7a-b458-e71e9a2eede9',5,NULL,17,'FRONT_WHEEL','2026-08-20','2026-08-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(19,'1a061266-fb1d-48d2-812e-f0ff40ac901d',6,NULL,17,'REAR_WHEEL','2026-08-20','2026-08-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "installation" VALUES(20,'423f539c-3c5c-4d0d-b7de-f659ab234f5e',18,1,NULL,'SHIFTERS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(21,'378e0dc1-b07c-48b7-8cdb-25a7f97cb968',19,1,NULL,'FRONT_DERAILLEUR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(22,'eee18923-46ae-4ba5-8e24-570dfe4d7764',20,1,NULL,'REAR_DERAILLEUR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(23,'f03e5a88-0498-436a-bd5e-30b66356a699',21,NULL,20,'PULLEY_UPPER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(24,'f08fdd30-353b-420f-9e22-16301fb873f4',22,NULL,20,'PULLEY_LOWER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(25,'b13c3c06-17c2-49ff-9df1-e893d6e98885',23,1,NULL,'CRANKSET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(26,'ca98ac11-4e0a-444d-81f3-4a3d2dd741ef',24,NULL,23,'CHAINRING_OUTER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(27,'884dc835-b3da-46e7-9a76-12f621e407eb',25,NULL,23,'CHAINRING_INNER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(28,'e967f1d8-aa7a-41a9-b830-4bdf0f549ed7',26,1,NULL,'BOTTOM_BRACKET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(29,'50539e83-9948-4b16-8421-835052b359da',27,NULL,6,'CASSETTE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(30,'770e5738-85bf-416c-adbd-5d94afd324cf',28,1,NULL,'CHAIN','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(31,'5b3c4958-281c-4326-8ea3-ffae26597dc3',29,NULL,28,'QUICK_LINK','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(32,'11a365b4-82c6-46ef-bef0-45608ceeed81',30,1,NULL,'FRONT_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(33,'374e1938-3590-40f5-b6c3-276443405fc8',31,1,NULL,'REAR_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(34,'7168f55e-c8c4-4e9a-a12d-5cc9f0ecdea4',32,1,NULL,'FRONT_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(35,'9f174edd-02f4-41c1-93bc-2736f0c90879',33,1,NULL,'REAR_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(36,'10df050c-7a12-40cd-a54c-545bc28ec73d',34,NULL,5,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(37,'4fe9e8ed-34d4-4bab-89fe-2ca5fe02145e',35,NULL,6,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(38,'a609af9f-89ad-429a-84e8-f3934e7b6f66',36,1,NULL,'BATTERY','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:47Z',NULL,NULL,1,NULL);
INSERT INTO "installation" VALUES(39,'80341c13-5044-420a-a499-16696080cfe6',37,2,NULL,'SHIFTERS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(40,'1f59edbc-80c3-4d2a-bace-f1d077497bef',38,2,NULL,'REAR_DERAILLEUR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(41,'12c99088-f524-445d-acbe-a1b9e56c93d8',39,NULL,38,'PULLEY_UPPER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(42,'0a37c11f-bad1-4f04-9701-e1cbc8b9b3da',40,NULL,38,'PULLEY_LOWER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(43,'9b1744d9-c703-49c3-bf7c-80d4cff1f9af',41,2,NULL,'CRANKSET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(44,'7a72cae4-8439-43a4-a82d-807404c36ca6',42,NULL,41,'CHAINRING_OUTER','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(45,'98a797cb-5bf9-402f-bd67-9257fed4b1d3',43,2,NULL,'BOTTOM_BRACKET','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(46,'cca10701-249f-4f30-9d8c-438b52847125',44,NULL,12,'CASSETTE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(47,'922b998a-7f53-4a11-a51b-4aebb0587d66',45,2,NULL,'CHAIN','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(48,'65dafa3f-f080-420b-82ae-6dcbe1837cb0',46,NULL,45,'QUICK_LINK','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(49,'f9639738-583e-46d5-aefb-c1da84b884e0',47,2,NULL,'FRONT_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(50,'ed77ae45-c506-46d9-b6ba-be0207ddbc86',48,2,NULL,'REAR_BRAKE','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(51,'3e021d34-5569-4540-8a77-405c4fe49219',49,2,NULL,'FRONT_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(52,'4e7306dd-af62-488d-bc36-5a9fd55d7bfe',50,2,NULL,'REAR_PADS','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(53,'c0043b9e-e364-4d93-b566-d4ab5cc8b3f8',51,NULL,11,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(54,'1c1c1767-cbe2-4722-a4fa-ca92fd7a903e',52,NULL,12,'ROTOR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(55,'de731b01-c663-408b-bdfc-fea9e87f04cd',53,2,NULL,'SHIFT_CABLE_REAR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(56,'0bfa52b6-be9e-4498-866e-0566fe33368a',54,2,NULL,'SHIFT_HOUSING_REAR','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,2,NULL);
INSERT INTO "installation" VALUES(57,'acd19459-6b71-4282-b5b2-494adade8895',55,NULL,6,'TUBE','2026-08-22T10:00:00Z','2026-08-22T10:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL,NULL,NULL,NULL);
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
INSERT INTO "journal_entry" VALUES(1,'7b7e1b99-a4a9-41f1-81dd-8a11c570f155',1,10,'2026-08-22','ISSUE','Pinch flat on a pothole, swapped the tube at the roadside.','2026-08-22','2026-11-14T18:52:48Z',NULL,NULL,NULL,1,'FLAT','bd2a5064-846b-4f91-b4b1-6773487a37c3',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "journal_entry" VALUES(2,'46dc5f19-788c-44c2-8036-d2f8f13b96a3',2,NULL,'2026-09-27','ISSUE','Slid out on wet leaves in a corner; scraped bar tape and rear derailleur.',NULL,'2026-11-14T18:52:48Z',NULL,NULL,NULL,18,'CRASH','097f6b7f-ec40-4f35-94a4-8228fd7ac106',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "journal_entry" VALUES(3,'b005a8e1-5333-4019-bdfb-1ac4e161b62c',1,23,'2026-10-15','ISSUE','Creak under load from the bottom bracket area.',NULL,'2026-11-14T18:52:48Z',NULL,NULL,NULL,25,'DEFECT','a3fe58a6-d21a-4d0e-bf54-20a4498799b1',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "journal_entry" VALUES(4,'17e49b8d-a07b-4658-b24d-32433f34763f',1,NULL,'2026-08-19','NOTE','Fitted 32 mm tires; clearance is fine.',NULL,'2026-11-14T18:52:48Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
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
	created_at VARCHAR(20) NOT NULL, work_session_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(bike_id) REFERENCES bike (id), 
	FOREIGN KEY(component_id) REFERENCES component (id), 
	FOREIGN KEY(consumable_id) REFERENCES consumable (id), 
	UNIQUE (uuid)
);
INSERT INTO "maintenance_event" VALUES(1,'0e2545fa-c1d6-4916-bba6-1bf76e03c0c3','WAX_HOT',28,1,'2026-08-19','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,1,30.0,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
INSERT INTO "maintenance_event" VALUES(2,'7c0a9a02-0793-4c7e-8142-42cfa69dc458','LUBE',45,2,'2026-08-19','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'wet lube for winter',NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
INSERT INTO "maintenance_event" VALUES(3,'679c7d13-537d-43b5-9c83-4f6e7e396db4','BATTERY_CHARGE',36,1,'2026-08-19','2026-08-19','2026-08-18T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
INSERT INTO "maintenance_event" VALUES(4,'780912d9-7b1b-429c-a703-d53423075f50','WAX_LIQUID',28,1,'2026-09-05','2026-09-05','2026-09-04T22:00:00Z',NULL,NULL,NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
INSERT INTO "maintenance_event" VALUES(5,'7d812bcc-f7cc-48ba-aa85-fa9c12614998','WAX_HOT',28,1,'2026-09-20','2026-09-20','2026-09-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,1,30.0,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
INSERT INTO "maintenance_event" VALUES(6,'b4f17162-44bd-42e3-8516-6a1a1ff2f10b','BATTERY_CHARGE',36,1,'2026-09-20','2026-09-20','2026-09-19T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
INSERT INTO "maintenance_event" VALUES(7,'fdfeabf6-2769-4c20-8123-1615d23666ee','CHAIN_MEASURE_WEAR',28,1,'2026-09-20','2026-09-20','2026-09-19T22:00:00Z',NULL,NULL,'OK',0.1,'%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
INSERT INTO "maintenance_event" VALUES(8,'c3d640fc-441a-4a7d-9bba-faab3c91dcb8','PAD_MEASURE',50,2,'2026-09-30','2026-09-30','2026-09-29T22:00:00Z',NULL,NULL,'OK',1.4,'mm',NULL,NULL,NULL,'gritty winter roads',NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
INSERT INTO "maintenance_event" VALUES(9,'6643b215-e130-42e0-bcd2-e52ccb2212fe','LUBE',45,2,'2026-09-30','2026-09-30','2026-09-29T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
INSERT INTO "maintenance_event" VALUES(10,'4c7f6658-cb6d-423d-b420-efc5ab8e0568','FREEHUB_SERVICE',6,1,'2026-08-06','2026-08-06','2026-08-05T22:00:00Z',NULL,NULL,NULL,NULL,NULL,NULL,NULL,4500,'done by the seller before the wheel was sold',NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
CREATE TABLE operation (
	id INTEGER NOT NULL, 
	client_op_id VARCHAR(64) NOT NULL, 
	kind VARCHAR(48) NOT NULL, 
	result_json TEXT NOT NULL, 
	created_at VARCHAR(20) NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (client_op_id)
);
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
INSERT INTO "product" VALUES(1,'ccde72d1-a8df-4c41-a1ed-869f1a7eb5e8','SHIFTERS','Shimano','ST-R8170','{"function": "Dual control levers, 2\u00d712 Di2, hydraulic disc brake", "connection": "Wireless to the derailleurs", "power": "CR1632 coin cell in each lever", "brake fluid": "Shimano mineral oil"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(2,'91abd2b4-0347-41f6-b069-b0abbdd572fa','FRONT_DERAILLEUR','Shimano','FD-R8150','{"speeds": "2\u00d712", "mount": "Braze-on", "max chainring": "52T", "front capacity": "16T", "wire": "EW-SD300"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(3,'f8e327d6-313e-43e7-8b8f-7e115b23c874','REAR_DERAILLEUR','Shimano','RD-R8150','{"speeds": "12", "max low sprocket": "34T", "total capacity": "39T", "charging": "Charging port for EW-EC300", "wire": "EW-SD300"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(4,'60457d9e-af4d-4bac-9be4-28fc3866cc0b','PULLEY_WHEEL','Shimano','RD-R8150 guide pulley','{"speeds": "12", "teeth": "13"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(5,'608e64aa-89b7-47f2-9454-798c75d0a023','PULLEY_WHEEL','Shimano','RD-R8150 tension pulley','{"speeds": "12", "teeth": "13"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(6,'82e1c2af-b73d-493e-9647-a191fad17304','CRANKSET','Shimano','FC-R8100 172.5 mm','{"speeds": "2\u00d712", "crank length": "172.5 mm", "chainrings": "52-36T", "spindle": "Hollowtech II, 24 mm", "power meter": "none"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(7,'84b4e1df-0f7c-4983-a539-fb898052ae08','CHAINRING','Shimano','FC-R8100 chainring 52T','{"teeth": "52", "position": "outer", "for": "FC-R8100 52-36T"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(8,'55d89f7d-c823-4c9d-a8cf-03cc4eb32378','CHAINRING','Shimano','FC-R8100 chainring 36T','{"teeth": "36", "position": "inner", "for": "FC-R8100 52-36T"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(9,'9df5da0f-97e8-4748-9efe-4ebe9e6e9191','BOTTOM_BRACKET','Shimano','SM-BB-R60','{"standard": "BSA threaded, 68 mm shell", "spindle": "24 mm (Hollowtech II)"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(10,'0f70ebad-f1c5-4975-9c7d-086a75062c56','CASSETTE','Shimano','CS-R8100-12 11-34','{"speeds": "12", "range": "11-34T", "sprockets": "11-12-13-14-15-17-19-21-24-27-30-34", "freehub": "Shimano HG 11-speed road (and 12-speed road) freehub"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(11,'23e7a498-7584-43b5-ba4d-8d0ceaeabbb8','CHAIN','Shimano','CN-M8100','{"speeds": "12 (Hyperglide+)", "links": "116 (shorten to fit)", "joining": "Quick link SM-CN910-12"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(12,'f1b30a1f-8816-47f9-939a-0867566889b9','QUICK_LINK','Shimano','SM-CN910-12','{"speeds": "12", "reuse": "Shimano recommends a new link after opening"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(13,'7730196b-bae4-425c-998a-c627f1a5e002','BRAKE_CIRCUIT','Shimano','BR-R8170 front','{"caliper": "BR-R8170, flat mount, 2 pistons", "lever": "ST-R8170", "hose": "SM-BH90-JK-SSR", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(14,'68f79dc4-823c-46d5-b0a6-396b87a0d5a6','BRAKE_CIRCUIT','Shimano','BR-R8170 rear','{"caliper": "BR-R8170, flat mount, 2 pistons", "lever": "ST-R8170", "hose": "SM-BH90-JK-SSR", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(15,'e213dfae-0277-48b3-9c1e-c1f0611b589d','BRAKE_PADS','Shimano','L05A-RF','{"compound": "Resin", "cooling": "Fins", "fits": "BR-R8170 (also K05S-RX resin, no fins)"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(16,'02b71eb0-539b-41be-bb31-f76cc6dc94e9','BRAKE_ROTOR','Shimano','RT-CL800 160 mm','{"size": "160 mm", "mount": "Center Lock", "technology": "Ice Tech Freeza", "alternative": "RT-MT800 (same size) is also listed for this caliper"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(17,'304ad9d9-4659-4d10-8d62-5076b29f1eb6','BRAKE_ROTOR','Shimano','RT-CL800 140 mm','{"size": "140 mm", "mount": "Center Lock", "technology": "Ice Tech Freeza", "alternative": "RT-MT800 (same size) is also listed for this caliper"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(18,'e2963700-9c7c-45ce-b240-f4edecff7b41','BATTERY','Shimano','BT-DN300','{"type": "Internal (seatpost or frame)", "ports": "3 \u00d7 EW-SD300", "charging": "EW-EC300 cable at the rear derailleur port"}','Retailer listings of the R8100 Di2 groupset and its parts, 2026-10-25; not yet checked against productinfo.shimano.com','groupset template SHIMANO_ULTEGRA_DI2_R8100, 2026-10-25','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:47Z',NULL);
INSERT INTO "product" VALUES(19,'06486d34-ecce-48a7-ae17-a4a6a34af24f','SHIFTERS','Shimano','ST-RX820','{"function": "Shift/brake lever right (1\u00d712 mechanical) + brake lever left, hydraulic disc", "brake fluid": "Shimano mineral oil"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(20,'2ebe70a2-7fed-4e2f-a7fd-fa1592965d4b','REAR_DERAILLEUR','Shimano','RD-RX822-SGS','{"speeds": "12", "max low sprocket": "51T", "clutch": "Shadow RD+"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(21,'e5b640a7-6fa4-4773-a669-046790f97001','PULLEY_WHEEL','Shimano','RD-RX822 guide pulley','{"speeds": "12", "teeth": "13"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(22,'9f7a0349-3c31-48e3-bffc-7c96f29b453b','PULLEY_WHEEL','Shimano','RD-RX822 tension pulley','{"speeds": "12", "teeth": "13"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(23,'177ff047-dc02-4bf1-a68e-a638a08ceb1a','CRANKSET','Shimano','FC-RX820-1 172.5 mm','{"speeds": "1\u00d712", "crank length": "172.5 mm", "chainring": "40T", "spindle": "Hollowtech II, 24 mm"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(24,'1f1172df-08ca-4eba-a509-59fad4aefaea','CHAINRING','Shimano','SM-CRX820-1 40T','{"teeth": "40", "position": "single (1\u00d7)"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(25,'5e6336c3-a4ac-4536-a833-0771e33e2ddb','CASSETTE','Shimano','CS-M8100-12 10-45','{"speeds": "12", "range": "10-45T", "sprockets": "10-12-14-16-18-21-24-28-32-36-40-45", "freehub": "Shimano Micro Spline"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(26,'fe54a31c-c336-4560-bf16-e8d4ea7d5d76','BRAKE_CIRCUIT','Shimano','BR-RX820 front','{"caliper": "BR-RX820, flat mount, 2 pistons", "lever": "ST-RX820", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(27,'4cd32469-f8f4-4480-a1c2-97e0c3e01ffd','BRAKE_CIRCUIT','Shimano','BR-RX820 rear','{"caliper": "BR-RX820, flat mount, 2 pistons", "lever": "ST-RX820", "fluid": "Shimano mineral oil", "rotor": "140 / 160 mm"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(28,'e2f7f3eb-dda6-44e1-934c-577e672717ec','BRAKE_ROTOR','Shimano','RT-MT800 160 mm','{"size": "160 mm", "mount": "Center Lock", "technology": "Ice Tech Freeza"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(29,'58cba111-33a1-475c-89b9-272f7bbd23ce','SHIFT_CABLE','Shimano','Shimano shift cable','{"position": "rear"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(30,'507ab1bc-f384-4e45-aa1d-49f558d93f88','SHIFT_HOUSING','Shimano','Shimano shift housing','{"position": "rear"}','Retailer listings and launch news of GRX RX820/RX825 (bike-components.de, bike24.com, eatsleepcycle.com, veloplus.ee, road.cc), 2026-10-26; not yet checked against productinfo.shimano.com','groupset template SHIMANO_GRX_RX820_1X12, 2026-10-26','Specs from the groupset template, not verified against the maker''s documentation','2026-11-14T18:52:48Z',NULL);
INSERT INTO "product" VALUES(31,'f5937b43-5985-4b57-a1af-d485db6c610d','INNER_TUBE','Sample','Road tube 700×28-32','{}',NULL,NULL,NULL,'2026-11-14T18:52:48Z',NULL);
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
INSERT INTO "purchase_bundle" VALUES(1,'21f9a6e1-490e-4995-b174-c43007ada106','Shimano Ultegra Di2 R8100 · 2×12 · hydraulic disc groupset','Sample shop','2026-08-11',165000,NULL,1,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z',NULL,NULL);
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
INSERT INTO "ride" VALUES(1,'1b49654a-ba54-4af2-8da7-8fcae0c3337d',1,'Coffee ride','2026-08-22',NULL,'2026-08-21T22:00:00Z',78.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(2,'cea08533-5dd9-46a0-b92c-7b01cbf48f48',1,'Vineyards','2026-08-25',NULL,'2026-08-24T22:00:00Z',83.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(3,'22ed0066-becd-40fc-9070-84bea702f7f2',1,'Coffee ride','2026-08-27',NULL,'2026-08-26T22:00:00Z',87.2,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(4,'7dc02cc4-bf92-4642-bf85-3db16264bccd',1,'Zwift workout','2026-08-29','2026-08-29T16:30:00Z','2026-08-29T16:30:00Z',38.4,3600,'VirtualRide',2,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z',NULL);
INSERT INTO "ride" VALUES(5,'918a8961-627c-4e22-a166-7da3fb95b1ac',2,'Long Sunday','2026-08-30',NULL,'2026-08-29T22:00:00Z',55.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','WET');
INSERT INTO "ride" VALUES(6,'c89871e0-b84b-418b-88b7-c6bdad377c47',1,'Coffee ride','2026-09-05',NULL,'2026-09-04T22:00:00Z',78.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(7,'d5b58368-2bd6-4b15-b7c5-8fa751c5ee2f',2,'Club ride','2026-09-06',NULL,'2026-09-05T22:00:00Z',66.9,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','WET');
INSERT INTO "ride" VALUES(8,'0689bc46-a379-4776-b55a-2476f292826c',1,'After work','2026-09-10',NULL,'2026-09-09T22:00:00Z',37.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(9,'8455c4d1-17fe-4054-bb2d-156dc901c81d',1,'Vineyards','2026-09-12',NULL,'2026-09-11T22:00:00Z',84.8,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(10,'1b533c0a-484d-495d-8d7f-08c473f03447',2,'Recovery spin','2026-09-13',NULL,'2026-09-12T22:00:00Z',80.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(11,'d3313e67-cabc-4169-b88e-6e00a6e7c178',1,'Recovery spin','2026-09-15',NULL,'2026-09-14T22:00:00Z',106.8,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(12,'c1861d43-9d39-44af-a624-3a53efbdb312',1,'Hill repeats','2026-09-17',NULL,'2026-09-16T22:00:00Z',37.2,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(13,'c40fb88e-2603-42d4-9d8b-ebe20a8b0329',1,'Coffee ride','2026-09-19',NULL,'2026-09-18T22:00:00Z',79.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(14,'798614d8-00aa-4ae2-bd88-838cd4ed2d55',2,'Hill repeats','2026-09-20',NULL,'2026-09-19T22:00:00Z',47.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(15,'89495e90-ea8c-4665-beb6-b433fa275def',1,'Gravel detour','2026-09-22',NULL,'2026-09-21T22:00:00Z',92.3,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(16,'2eda6bea-e4fc-4659-9ffd-c67f93b7a753',1,'Gravel detour','2026-09-24',NULL,'2026-09-23T22:00:00Z',81.6,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(17,'293b268c-a14f-4f7c-bbff-03e32b1afcaa',1,'Club ride','2026-09-26',NULL,'2026-09-25T22:00:00Z',52.2,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','WET');
INSERT INTO "ride" VALUES(18,'7b81273b-25a8-4475-8288-168f07e9bb1e',2,'Vineyards','2026-09-27',NULL,'2026-09-26T22:00:00Z',84.1,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(19,'7feb1301-b25b-4796-9f84-580e0ea382ee',1,'Zwift workout','2026-10-01','2026-10-01T16:30:00Z','2026-10-01T16:30:00Z',35.4,3600,'VirtualRide',2,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z',NULL);
INSERT INTO "ride" VALUES(20,'0b8bc538-0903-442a-9354-124e73cafb4b',1,'Long Sunday','2026-10-03',NULL,'2026-10-02T22:00:00Z',77.3,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(21,'5c0ed6fd-bfb8-4130-9c84-e3da473ca145',1,'Coffee ride','2026-10-06',NULL,'2026-10-05T22:00:00Z',112.9,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(22,'bc693fba-fd0c-4a1c-ae7d-2c2208feb005',1,'River path','2026-10-08',NULL,'2026-10-07T22:00:00Z',57.0,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(23,'33e1bd45-53f7-4ff3-b1a8-4770ac7369cf',1,'Club ride','2026-10-10',NULL,'2026-10-09T22:00:00Z',40.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(24,'6c6dd771-d9ba-4a53-a501-e1ac429e7d0e',2,'Long Sunday','2026-10-11',NULL,'2026-10-10T22:00:00Z',49.7,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','WET');
INSERT INTO "ride" VALUES(25,'b7c65438-48a2-475a-8897-9488a4733b9f',1,'Coffee ride','2026-10-15',NULL,'2026-10-14T22:00:00Z',81.5,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','DRY');
INSERT INTO "ride" VALUES(26,'ab2c39fa-33d5-4179-9b30-8ff235c2fea5',1,'Zwift workout','2026-10-17','2026-10-17T16:30:00Z','2026-10-17T16:30:00Z',25.7,3600,'VirtualRide',2,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z',NULL);
INSERT INTO "ride" VALUES(27,'3b8d61e8-f231-42ed-b894-9a30b81c1147',2,'After work','2026-10-18',NULL,'2026-10-17T22:00:00Z',53.4,NULL,'Ride',NULL,'MANUAL','ACTIVE','INCLUDED',NULL,0,NULL,NULL,'2026-11-14T18:52:48Z','2026-11-14T18:52:48Z','WET');
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
CREATE TABLE "service_rule" (
        id INTEGER NOT NULL, uuid VARCHAR(36) NOT NULL, rule_code VARCHAR(48) NOT NULL, name TEXT NOT NULL,
        component_type VARCHAR(32), component_id INTEGER, bike_id INTEGER, action_code VARCHAR(32) NOT NULL,
        "trigger" VARCHAR(20) NOT NULL, interval_km FLOAT, interval_months INTEGER,
        window_min_km FLOAT, window_max_km FLOAT, cycle_action_code VARCHAR(32), reset_actions_json TEXT NOT NULL,
        warn_km FLOAT, warn_days INTEGER, origin VARCHAR(16) NOT NULL, active BOOLEAN NOT NULL, notes TEXT,
        created_at VARCHAR(20) NOT NULL, updated_at VARCHAR(20) NOT NULL, requires_setup VARCHAR(12),
        interval_hours FLOAT, warn_hours FLOAT, interval_count INTEGER,
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
INSERT INTO "service_rule" VALUES(1,'bbd9dc3a-c779-4e1c-a4c2-252d9b735e0c','CHAIN_HOT_WAX','Hot wax chain','CHAIN',NULL,NULL,'WAX_HOT','INTERVAL',500.0,NULL,NULL,NULL,NULL,'["WAX_HOT"]',50.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(2,'3bd8d947-eca4-4616-8b3e-281f426f04ed','CHAIN_LIQUID_WAX','Liquid-wax top-up','CHAIN',NULL,NULL,'WAX_LIQUID','CYCLE_WINDOW',NULL,NULL,250.0,300.0,'WAX_HOT','["WAX_LIQUID"]',25.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(3,'dc7b8609-6ab7-4edb-a456-4c322bf41cc1','CHAIN_WEAR_CHECK','Measure chain wear','CHAIN',NULL,NULL,'CHAIN_MEASURE_WEAR','INTERVAL',1000.0,NULL,NULL,NULL,NULL,'["CHAIN_MEASURE_WEAR"]',100.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(4,'84dee3f7-d6b2-4808-b0b7-2336810c7373','BRAKE_FLUID','Replace brake fluid','BRAKE_CIRCUIT',NULL,NULL,'BRAKE_FLUID_REPLACE','INTERVAL',NULL,24,NULL,NULL,NULL,'["BRAKE_FLUID_REPLACE"]',NULL,30,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(5,'a132dd0c-a165-4185-9abf-e6cde8b285a5','BRAKE_PAD_CHECK','Check brake pads','BRAKE_PADS',NULL,NULL,'PAD_MEASURE','INTERVAL',1000.0,NULL,NULL,NULL,NULL,'["PAD_MEASURE"]',100.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(6,'83f2b48c-7604-48e8-a225-037e45774fbb','FRONT_WHEEL_INSPECTION','Inspect wheel','FRONT_WHEEL',NULL,NULL,'WHEEL_INSPECT','INTERVAL',3000.0,12,NULL,NULL,NULL,'["WHEEL_INSPECT"]',200.0,30,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(7,'ae897320-715e-4360-8aad-12ccde773047','REAR_WHEEL_INSPECTION','Inspect wheel','REAR_WHEEL',NULL,NULL,'WHEEL_INSPECT','INTERVAL',3000.0,12,NULL,NULL,NULL,'["WHEEL_INSPECT"]',200.0,30,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(8,'75100cf4-fe8d-45e2-8936-41ca0d9a8c50','FRONT_HUB_BEARINGS','Service hub bearings','FRONT_WHEEL',NULL,NULL,'HUB_BEARING_SERVICE','INTERVAL',10000.0,NULL,NULL,NULL,NULL,'["HUB_BEARING_SERVICE"]',500.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(9,'5bde057b-d763-4e60-b1e1-b7e2d5bed1e3','REAR_HUB_BEARINGS','Service hub bearings','REAR_WHEEL',NULL,NULL,'HUB_BEARING_SERVICE','INTERVAL',10000.0,NULL,NULL,NULL,NULL,'["HUB_BEARING_SERVICE"]',500.0,NULL,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(10,'8e67d398-792e-4b9f-a8c1-56dcb73eb2f2','FREEHUB','Service freehub','REAR_WHEEL',NULL,NULL,'FREEHUB_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["FREEHUB_SERVICE"]',300.0,30,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(11,'cd9bf2ed-2b93-4f5b-8c47-b0145c8bad5d','TIRE_CHECK','Inspect tire','TIRE',NULL,NULL,'TIRE_INSPECT','INTERVAL',1000.0,12,NULL,NULL,NULL,'["TIRE_INSPECT"]',100.0,30,'DEFAULT',1,'Yearly also for sidewall cracks from age; no bicycle-tire age limit was found.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(12,'fde3beb1-3da9-493b-b7c2-e9b2eb890197','TIRE_SEALANT','Top up sealant','TIRE',NULL,NULL,'SEALANT_TOP_UP','INTERVAL',NULL,3,NULL,NULL,NULL,'["SEALANT_TOP_UP", "SEALANT_RENEW"]',NULL,14,'MANUFACTURER',1,'Stan''s: sealant lasts 2–6 months; check every 3 months (stans.com sealant support).','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','TUBELESS',NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(13,'77b130f2-b33d-4ae1-8039-daed2c2b98db','TIRE_SEALANT_RENEW','Clean out and renew sealant','TIRE',NULL,NULL,'SEALANT_RENEW','INTERVAL',NULL,12,NULL,NULL,NULL,'["SEALANT_RENEW"]',NULL,30,'MANUFACTURER',1,'Stan''s: take the tire off and clean out old sealant once a year; check rim tape and valves at the same time (stans.com sealant support).','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','TUBELESS',NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(14,'a9f9703c-20ae-4da8-acde-c5d70a921383','VALVE_CORE','Replace valve core','TUBELESS_VALVE',NULL,NULL,'VALVE_CORE_REPLACE','INTERVAL',NULL,12,NULL,NULL,NULL,'["VALVE_CORE_REPLACE"]',NULL,30,'DEFAULT',1,'At the yearly sealant clean-out; personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','TUBELESS',NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(15,'8b998b9e-cf84-4842-86d4-ddbb8dcddada','FRONT_THRU_AXLE','Check and grease thru-axle','FRONT_WHEEL',NULL,NULL,'THRU_AXLE_SERVICE','INTERVAL',NULL,6,NULL,NULL,NULL,'["THRU_AXLE_SERVICE"]',NULL,14,'DEFAULT',1,'Personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(16,'f4827c3c-921e-49c5-b111-52ccf9c90e25','REAR_THRU_AXLE','Check and grease thru-axle','REAR_WHEEL',NULL,NULL,'THRU_AXLE_SERVICE','INTERVAL',NULL,6,NULL,NULL,NULL,'["THRU_AXLE_SERVICE"]',NULL,14,'DEFAULT',1,'Personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(17,'1b0b87d7-4f19-46dd-9e46-7b3085c7fac6','HEADSET_SERVICE','Service headset','HEADSET',NULL,NULL,'HEADSET_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["HEADSET_SERVICE"]',300.0,30,'DEFAULT',1,NULL,'2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(18,'528a73e9-f531-439d-bec2-efb32a490add','DI2_BATTERY_CHARGE','Charge Di2 battery','BATTERY',NULL,NULL,'BATTERY_CHARGE','INTERVAL',800.0,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',100.0,NULL,'DEFAULT',1,'Shimano BT-DN300: about 1000 km per charge (less with much front shifting); 800 km leaves a margin. Source: retailer listings (Rose, Tweeks), not verified with Shimano.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(19,'7875a575-c97d-4bfb-85bc-b61c1dd3f0ee','POWER_METER_CHARGE','Charge power meter','POWER_METER',NULL,NULL,'POWER_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["POWER_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your power meter''s battery life with a margin.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,50.0,10.0,NULL);
INSERT INTO "service_rule" VALUES(20,'10f2ab17-b959-48d2-b5f5-1c2b1ca577cc','POWER_PEDALS_CHARGE','Charge power-meter pedals','POWER_METER_PEDALS',NULL,NULL,'POWER_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["POWER_CHARGE"]',NULL,NULL,'DEFAULT',1,'Favero Assioma PRO RS-1: at least 60 h per charge (up to about 160 h after a firmware update). 80 h is your choice (2026-10-26). Source: retailer listings quoting Favero, not verified.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,80.0,10.0,NULL);
INSERT INTO "service_rule" VALUES(21,'e2343f7d-95b4-4337-8ba5-66b716816df1','SENSOR_BATTERY','Replace sensor battery','SENSOR',NULL,NULL,'COIN_CELL_REPLACE','INTERVAL',NULL,12,NULL,NULL,NULL,'["COIN_CELL_REPLACE"]',NULL,30,'DEFAULT',1,'Magene S3+ (CR2032): about 500 h of riding per battery (retailer listings, not verified with Magene); 400 h leaves a margin. 12 months covers standby drain (your estimate).','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,400.0,40.0,NULL);
INSERT INTO "service_rule" VALUES(22,'190d33b5-693c-4b22-a6a2-9a1f7d07b3de','SHIFTER_COIN_CELLS','Replace shifter coin cells','SHIFTERS',NULL,NULL,'COIN_CELL_REPLACE','INTERVAL',NULL,18,NULL,NULL,NULL,'["COIN_CELL_REPLACE"]',NULL,30,'DEFAULT',0,'Wireless Di2 levers (CR1632): about 1.5–2 years (retailer listings); 18 months leaves a margin. Off by default (wired and mechanical levers have no coin cell); switch it on for wireless levers. Keep CR1632 cells as counted stock to pick them when logging.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(23,'b3647793-b211-478f-b604-0588b59dbf7a','COMPUTER_CHARGE','Charge bike computer','BIKE_COMPUTER',NULL,NULL,'BATTERY_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your device''s battery life with a margin (personal value).','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,20.0,4.0,NULL);
INSERT INTO "service_rule" VALUES(24,'7203383e-9a1c-462f-997c-ef7db8a5c234','LIGHT_CHARGE','Charge light','LIGHT',NULL,NULL,'BATTERY_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your light''s run time in the mode you use (personal value).','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,4.0,1.0,NULL);
INSERT INTO "service_rule" VALUES(25,'d26b5e10-13c3-484b-8be9-7da1cfd439bc','RADAR_CHARGE','Charge radar','RADAR',NULL,NULL,'BATTERY_CHARGE','INTERVAL',NULL,NULL,NULL,NULL,NULL,'["BATTERY_CHARGE"]',NULL,NULL,'DEFAULT',1,'Set to your radar''s run time in the mode you use (personal value).','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,6.0,2.0,NULL);
INSERT INTO "service_rule" VALUES(26,'275972f7-5325-4344-9e5c-89db0ea46225','PULLEY_CHECK','Check pulley wheels','PULLEY_WHEEL',NULL,NULL,'PULLEY_INSPECT','INTERVAL',5000.0,NULL,NULL,NULL,NULL,'["PULLEY_INSPECT"]',300.0,NULL,'DEFAULT',1,'Common workshop practice, not a maker''s figure.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(27,'b5502988-0452-4b93-9294-7c41fc513a4a','CHAINRING_CHECK','Check chainring wear','CHAINRING',NULL,NULL,'CHAINRING_INSPECT','INTERVAL',5000.0,NULL,NULL,NULL,NULL,'["CHAINRING_INSPECT"]',300.0,NULL,'DEFAULT',1,'Check at least at every chain change; common practice, not a maker''s figure.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(28,'b6df557d-23c4-4b0d-aead-c254bab808cf','QUICK_LINK_CHAINS','Replace quick link','QUICK_LINK',NULL,NULL,'QUICK_LINK_CHECK','PARENT_COUNT',NULL,NULL,NULL,NULL,NULL,'["QUICK_LINK_CHECK"]',NULL,NULL,'DEFAULT',1,'Wippermann Connex links are sold as reusable many times; no official limit was found. Replace after 2 chains (your choice) or as soon as it closes noticeably looser than new.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,2);
INSERT INTO "service_rule" VALUES(29,'9b70be8d-4418-4eed-82ca-fa61d28ee1bb','RIM_TAPE_CHECK','Check rim tape','RIM_TAPE',NULL,NULL,'RIM_TAPE_CHECK','INTERVAL',NULL,12,NULL,NULL,NULL,'["RIM_TAPE_CHECK"]',NULL,30,'DEFAULT',1,'Check at every tire change or yearly (tubes: tape covers the spoke holes; tubeless: it seals).','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(30,'2417226a-2fbc-4854-96f7-09200aba8019','HOSE_CHECK','Inspect brake hoses and caliper','BRAKE_CIRCUIT',NULL,NULL,'HOSE_INSPECT','INTERVAL',NULL,12,NULL,NULL,NULL,'["HOSE_INSPECT", "BRAKE_FLUID_REPLACE"]',NULL,30,'DEFAULT',1,'With every fluid change or yearly; personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(31,'21db3075-3d88-4503-b698-7ca36b08771a','PAD_BED_IN','Bed in new pads','BRAKE_PADS',NULL,NULL,'BED_IN','ONCE_AFTER_INSTALL',NULL,NULL,NULL,100.0,NULL,'["BED_IN"]',NULL,NULL,'DEFAULT',1,'Once after fitting; after 100 km without it the pads count as bedded in.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(32,'300a7738-d4f7-4c30-a4be-641eec4827bb','ROTOR_BED_IN','Bed in new rotor','BRAKE_ROTOR',NULL,NULL,'BED_IN','ONCE_AFTER_INSTALL',NULL,NULL,NULL,100.0,NULL,'["BED_IN"]',NULL,NULL,'DEFAULT',1,'Once after fitting; after 100 km without it the rotor counts as bedded in.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(33,'7a2b9a07-1cb6-4c68-a824-291089f7eca8','PEDAL_BEARINGS','Service pedal bearings','PEDALS',NULL,NULL,'PEDAL_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["PEDAL_SERVICE"]',300.0,30,'DEFAULT',1,'Rider figure, not a maker''s interval.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(34,'16711dd3-0bec-4673-837d-ad8aef33fb33','POWER_PEDAL_BEARINGS','Service pedal bearings','POWER_METER_PEDALS',NULL,NULL,'PEDAL_SERVICE','INTERVAL',5000.0,12,NULL,NULL,NULL,'["PEDAL_SERVICE"]',300.0,30,'DEFAULT',1,'No Favero interval found; riders regrease Assioma pedals about yearly or every 2,500 km.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(35,'f48bb526-df23-4d37-8014-f2a1af45b8cb','BB_CHECK','Check bottom bracket','BOTTOM_BRACKET',NULL,NULL,'BB_INSPECT','INTERVAL',6000.0,12,NULL,NULL,NULL,'["BB_INSPECT"]',300.0,30,'DEFAULT',1,'Personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(36,'a06a6e30-7242-4eb7-a44f-3219debde3a9','BAR_TAPE_CHECK','Inspect bar tape','BAR_TAPE',NULL,NULL,'BAR_TAPE_INSPECT','INTERVAL',NULL,12,NULL,NULL,NULL,'["BAR_TAPE_INSPECT", "BAR_TAPE_REWRAP"]',NULL,30,'DEFAULT',1,'Personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(37,'79b652d4-9b0f-4ada-a6ff-f2333ece5e0f','SEATPOST_PASTE','Re-paste seatpost','SEATPOST',NULL,NULL,'SEATPOST_SERVICE','INTERVAL',NULL,12,NULL,NULL,NULL,'["SEATPOST_SERVICE"]',NULL,30,'DEFAULT',1,'Stops a seatpost from seizing; personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(38,'adf4d113-0351-4870-af48-d39a9d83ef29','HANGER_CHECK','Check derailleur hanger','DERAILLEUR_HANGER',NULL,NULL,'HANGER_ALIGN','INTERVAL',NULL,12,NULL,NULL,NULL,'["HANGER_ALIGN"]',NULL,30,'DEFAULT',1,'Also after every crash; personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(39,'4bd0136f-0b80-49d9-b5df-cdc43b9e900a','CLEAT_CHECK','Inspect cleats','CLEATS',NULL,NULL,'CLEAT_INSPECT','INTERVAL',2000.0,NULL,NULL,NULL,NULL,'["CLEAT_INSPECT"]',200.0,NULL,'DEFAULT',1,'Replace when a wear pad is worn through or clipping feels different, often about 6,000 km (rider figure; BikeRadar).','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(40,'3f0dfeb3-2fae-44f1-b318-27585fe1c48f','SHIFT_CABLE_CHECK','Check shift cable','SHIFT_CABLE',NULL,NULL,'CABLE_INSPECT','INTERVAL',5000.0,12,NULL,NULL,NULL,'["CABLE_INSPECT"]',300.0,30,'DEFAULT',1,'Personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','MECHANICAL',NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(41,'22513844-2bc5-410f-a7e8-87534ad2fff5','SHIFT_HOUSING_CHECK','Check shift housing','SHIFT_HOUSING',NULL,NULL,'CABLE_INSPECT','INTERVAL',5000.0,12,NULL,NULL,NULL,'["CABLE_INSPECT"]',300.0,30,'DEFAULT',1,'Personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','MECHANICAL',NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(42,'cb75f7df-ab3d-4755-8a42-8694f67854d0','BIKE_TORQUE_CHECK','Torque check','BIKE',NULL,NULL,'TORQUE_CHECK','INTERVAL',NULL,3,NULL,NULL,NULL,'["TORQUE_CHECK"]',NULL,14,'DEFAULT',1,'Every 3 months and once after the first ride on a newly fitted part (personal value). Torque values come from each product''s spec (torque_nm) where you entered it.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(43,'b98f632b-a0dd-482b-932c-cdf86a406d4b','BIKE_DI2_CHECK','Di2 check (firmware, errors)','BIKE',NULL,NULL,'DI2_SYSTEM_CHECK','INTERVAL',NULL,6,NULL,NULL,NULL,'["DI2_SYSTEM_CHECK"]',NULL,14,'DEFAULT',1,'Firmware is updated with Shimano E-TUBE; 6 months is a personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','ELECTRONIC',NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(44,'8cee2623-afd3-40b8-9d30-1cb0302550bb','BIKE_DI2_WIRES','Inspect Di2 wires','BIKE',NULL,NULL,'DI2_WIRE_INSPECT','INTERVAL',NULL,12,NULL,NULL,NULL,'["DI2_WIRE_INSPECT"]',NULL,30,'DEFAULT',1,'Personal value.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z','ELECTRONIC',NULL,NULL,NULL);
INSERT INTO "service_rule" VALUES(45,'10483073-d78a-4d54-aaef-754100061c3e','BIKE_FULL_SERVICE','Yearly full service','BIKE',NULL,NULL,'FULL_SERVICE','INTERVAL',NULL,12,NULL,NULL,NULL,'["FULL_SERVICE"]',NULL,30,'DEFAULT',1,'Once a year, a full service of the whole bike: Wheel hub bearings: play and roughness; Headset: clean, grease, check play; Bottom bracket: play and noise; Brakes: bleed (or check lever feel), hoses, pads, rotors; Di2 wires and junction / shift cables and housing; Frame and fork: cracks, dents, chips; Drivetrain: deep clean, chain, cassette and chainring wear; Pedals: bearing play; Torque check of all bolts. Personal value; each job keeps its own reminder.','2026-11-14T18:52:47Z','2026-11-14T18:52:47Z',NULL,NULL,NULL,NULL);
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
INSERT INTO "usage_adjustment" VALUES(1,'43bd0c5d-5210-4ba9-95ce-5f43cdf176e5',NULL,1,'STARTING','2026-08-19','2026-08-18T22:00:00Z',850.0,1,NULL,NULL,'2026-11-14T18:52:47Z');
INSERT INTO "usage_adjustment" VALUES(2,'673cbf9e-39f4-42dc-8a43-972923bdaf88',1,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',850.0,1,'from Aurora SL''s starting km',NULL,'2026-11-14T18:52:47Z');
INSERT INTO "usage_adjustment" VALUES(3,'254d93c3-1db9-48da-a703-fc6edfbcc3cf',2,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',850.0,1,'from Aurora SL''s starting km',NULL,'2026-11-14T18:52:47Z');
INSERT INTO "usage_adjustment" VALUES(4,'02f8e306-e6f0-4d98-9d41-7b3c6731c87d',NULL,2,'STARTING','2026-08-19','2026-08-18T22:00:00Z',4200.0,1,NULL,NULL,'2026-11-14T18:52:47Z');
INSERT INTO "usage_adjustment" VALUES(5,'0daefd09-2bc0-4434-ae26-2bf6ee69f187',3,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',4200.0,1,'from Winter Allroad''s starting km',NULL,'2026-11-14T18:52:47Z');
INSERT INTO "usage_adjustment" VALUES(6,'217f1c11-0d00-4d41-9603-22d1cf6cbb06',4,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',4200.0,1,'from Winter Allroad''s starting km',NULL,'2026-11-14T18:52:47Z');
INSERT INTO "usage_adjustment" VALUES(7,'9b9c00b4-141c-4dbc-a811-c9e21df40fa6',6,NULL,'STARTING','2026-08-19','2026-08-18T22:00:00Z',1200.0,1,'bought used; seller''s estimate',NULL,'2026-11-14T18:52:47Z');
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
INSERT INTO "usage_contribution" VALUES(1,2,1,'FORK','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,17,1,'WHEELSET','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,5,1,'FRONT_WHEEL','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,7,1,'TIRE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,8,1,'TUBE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,34,1,'ROTOR','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,6,1,'REAR_WHEEL','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,9,1,'TIRE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,10,1,'TUBE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,27,1,'CASSETTE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,35,1,'ROTOR','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,18,1,'SHIFTERS','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,19,1,'FRONT_DERAILLEUR','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,20,1,'REAR_DERAILLEUR','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,21,1,'PULLEY_UPPER','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,22,1,'PULLEY_LOWER','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,23,1,'CRANKSET','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,24,1,'CHAINRING_OUTER','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,25,1,'CHAINRING_INNER','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,26,1,'BOTTOM_BRACKET','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,28,1,'CHAIN','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,29,1,'QUICK_LINK','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,30,1,'FRONT_BRAKE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,31,1,'REAR_BRAKE','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,32,1,'FRONT_PADS','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,33,1,'REAR_PADS','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(1,36,1,'BATTERY','2026-08-21T22:00:00Z',78.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,1,1,'FRAME','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,2,1,'FORK','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,17,1,'WHEELSET','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,5,1,'FRONT_WHEEL','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,7,1,'TIRE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,8,1,'TUBE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,34,1,'ROTOR','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,6,1,'REAR_WHEEL','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,9,1,'TIRE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,27,1,'CASSETTE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,35,1,'ROTOR','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,55,1,'TUBE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,18,1,'SHIFTERS','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,19,1,'FRONT_DERAILLEUR','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,20,1,'REAR_DERAILLEUR','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,21,1,'PULLEY_UPPER','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,22,1,'PULLEY_LOWER','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,23,1,'CRANKSET','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,24,1,'CHAINRING_OUTER','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,25,1,'CHAINRING_INNER','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,26,1,'BOTTOM_BRACKET','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,28,1,'CHAIN','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,29,1,'QUICK_LINK','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,30,1,'FRONT_BRAKE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,31,1,'REAR_BRAKE','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,32,1,'FRONT_PADS','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,33,1,'REAR_PADS','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(2,36,1,'BATTERY','2026-08-24T22:00:00Z',83.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,1,1,'FRAME','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,2,1,'FORK','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,17,1,'WHEELSET','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,5,1,'FRONT_WHEEL','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,7,1,'TIRE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,8,1,'TUBE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,34,1,'ROTOR','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,6,1,'REAR_WHEEL','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,9,1,'TIRE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,27,1,'CASSETTE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,35,1,'ROTOR','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,55,1,'TUBE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,18,1,'SHIFTERS','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,19,1,'FRONT_DERAILLEUR','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,20,1,'REAR_DERAILLEUR','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,21,1,'PULLEY_UPPER','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,22,1,'PULLEY_LOWER','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,23,1,'CRANKSET','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,24,1,'CHAINRING_OUTER','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,25,1,'CHAINRING_INNER','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,26,1,'BOTTOM_BRACKET','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,28,1,'CHAIN','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,29,1,'QUICK_LINK','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,30,1,'FRONT_BRAKE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,31,1,'REAR_BRAKE','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,32,1,'FRONT_PADS','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,33,1,'REAR_PADS','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(3,36,1,'BATTERY','2026-08-26T22:00:00Z',87.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,1,1,'FRAME','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,2,1,'FORK','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,18,1,'SHIFTERS','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,19,1,'FRONT_DERAILLEUR','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,20,1,'REAR_DERAILLEUR','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,21,1,'PULLEY_UPPER','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,22,1,'PULLEY_LOWER','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,23,1,'CRANKSET','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,24,1,'CHAINRING_OUTER','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,25,1,'CHAINRING_INNER','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,26,1,'BOTTOM_BRACKET','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,28,1,'CHAIN','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,29,1,'QUICK_LINK','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,30,1,'FRONT_BRAKE','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,31,1,'REAR_BRAKE','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(4,36,1,'BATTERY','2026-08-29T16:30:00Z',38.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,3,2,'FRAME','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,4,2,'FORK','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,11,2,'FRONT_WHEEL','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,13,2,'TIRE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,14,2,'TUBE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,51,2,'ROTOR','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,12,2,'REAR_WHEEL','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,15,2,'TIRE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,16,2,'TUBE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,44,2,'CASSETTE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,52,2,'ROTOR','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,37,2,'SHIFTERS','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,38,2,'REAR_DERAILLEUR','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,39,2,'PULLEY_UPPER','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,40,2,'PULLEY_LOWER','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,41,2,'CRANKSET','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,42,2,'CHAINRING_OUTER','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,43,2,'BOTTOM_BRACKET','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,45,2,'CHAIN','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,46,2,'QUICK_LINK','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,47,2,'FRONT_BRAKE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,48,2,'REAR_BRAKE','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,49,2,'FRONT_PADS','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,50,2,'REAR_PADS','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,53,2,'SHIFT_CABLE_REAR','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(5,54,2,'SHIFT_HOUSING_REAR','2026-08-29T22:00:00Z',55.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,1,1,'FRAME','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,2,1,'FORK','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,17,1,'WHEELSET','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,5,1,'FRONT_WHEEL','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,7,1,'TIRE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,8,1,'TUBE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,34,1,'ROTOR','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,6,1,'REAR_WHEEL','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,9,1,'TIRE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,27,1,'CASSETTE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,35,1,'ROTOR','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,55,1,'TUBE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,18,1,'SHIFTERS','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,19,1,'FRONT_DERAILLEUR','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,20,1,'REAR_DERAILLEUR','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,21,1,'PULLEY_UPPER','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,22,1,'PULLEY_LOWER','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,23,1,'CRANKSET','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,24,1,'CHAINRING_OUTER','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,25,1,'CHAINRING_INNER','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,26,1,'BOTTOM_BRACKET','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,28,1,'CHAIN','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,29,1,'QUICK_LINK','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,30,1,'FRONT_BRAKE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,31,1,'REAR_BRAKE','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,32,1,'FRONT_PADS','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,33,1,'REAR_PADS','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(6,36,1,'BATTERY','2026-09-04T22:00:00Z',78.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,3,2,'FRAME','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,4,2,'FORK','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,11,2,'FRONT_WHEEL','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,13,2,'TIRE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,14,2,'TUBE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,51,2,'ROTOR','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,12,2,'REAR_WHEEL','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,15,2,'TIRE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,16,2,'TUBE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,44,2,'CASSETTE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,52,2,'ROTOR','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,37,2,'SHIFTERS','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,38,2,'REAR_DERAILLEUR','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,39,2,'PULLEY_UPPER','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,40,2,'PULLEY_LOWER','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,41,2,'CRANKSET','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,42,2,'CHAINRING_OUTER','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,43,2,'BOTTOM_BRACKET','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,45,2,'CHAIN','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,46,2,'QUICK_LINK','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,47,2,'FRONT_BRAKE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,48,2,'REAR_BRAKE','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,49,2,'FRONT_PADS','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,50,2,'REAR_PADS','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,53,2,'SHIFT_CABLE_REAR','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(7,54,2,'SHIFT_HOUSING_REAR','2026-09-05T22:00:00Z',66.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,1,1,'FRAME','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,2,1,'FORK','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,17,1,'WHEELSET','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,5,1,'FRONT_WHEEL','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,7,1,'TIRE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,8,1,'TUBE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,34,1,'ROTOR','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,6,1,'REAR_WHEEL','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,9,1,'TIRE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,27,1,'CASSETTE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,35,1,'ROTOR','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,55,1,'TUBE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,18,1,'SHIFTERS','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,19,1,'FRONT_DERAILLEUR','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,20,1,'REAR_DERAILLEUR','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,21,1,'PULLEY_UPPER','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,22,1,'PULLEY_LOWER','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,23,1,'CRANKSET','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,24,1,'CHAINRING_OUTER','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,25,1,'CHAINRING_INNER','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,26,1,'BOTTOM_BRACKET','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,28,1,'CHAIN','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,29,1,'QUICK_LINK','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,30,1,'FRONT_BRAKE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,31,1,'REAR_BRAKE','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,32,1,'FRONT_PADS','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,33,1,'REAR_PADS','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(8,36,1,'BATTERY','2026-09-09T22:00:00Z',37.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,1,1,'FRAME','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,2,1,'FORK','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,17,1,'WHEELSET','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,5,1,'FRONT_WHEEL','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,7,1,'TIRE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,8,1,'TUBE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,34,1,'ROTOR','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,6,1,'REAR_WHEEL','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,9,1,'TIRE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,27,1,'CASSETTE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,35,1,'ROTOR','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,55,1,'TUBE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,18,1,'SHIFTERS','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,19,1,'FRONT_DERAILLEUR','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,20,1,'REAR_DERAILLEUR','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,21,1,'PULLEY_UPPER','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,22,1,'PULLEY_LOWER','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,23,1,'CRANKSET','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,24,1,'CHAINRING_OUTER','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,25,1,'CHAINRING_INNER','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,26,1,'BOTTOM_BRACKET','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,28,1,'CHAIN','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,29,1,'QUICK_LINK','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,30,1,'FRONT_BRAKE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,31,1,'REAR_BRAKE','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,32,1,'FRONT_PADS','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,33,1,'REAR_PADS','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(9,36,1,'BATTERY','2026-09-11T22:00:00Z',84.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,3,2,'FRAME','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,4,2,'FORK','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,11,2,'FRONT_WHEEL','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,13,2,'TIRE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,14,2,'TUBE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,51,2,'ROTOR','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,12,2,'REAR_WHEEL','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,15,2,'TIRE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,16,2,'TUBE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,44,2,'CASSETTE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,52,2,'ROTOR','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,37,2,'SHIFTERS','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,38,2,'REAR_DERAILLEUR','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,39,2,'PULLEY_UPPER','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,40,2,'PULLEY_LOWER','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,41,2,'CRANKSET','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,42,2,'CHAINRING_OUTER','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,43,2,'BOTTOM_BRACKET','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,45,2,'CHAIN','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,46,2,'QUICK_LINK','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,47,2,'FRONT_BRAKE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,48,2,'REAR_BRAKE','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,49,2,'FRONT_PADS','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,50,2,'REAR_PADS','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,53,2,'SHIFT_CABLE_REAR','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(10,54,2,'SHIFT_HOUSING_REAR','2026-09-12T22:00:00Z',80.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,1,1,'FRAME','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,2,1,'FORK','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,17,1,'WHEELSET','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,5,1,'FRONT_WHEEL','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,7,1,'TIRE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,8,1,'TUBE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,34,1,'ROTOR','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,6,1,'REAR_WHEEL','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,9,1,'TIRE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,27,1,'CASSETTE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,35,1,'ROTOR','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,55,1,'TUBE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,18,1,'SHIFTERS','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,19,1,'FRONT_DERAILLEUR','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,20,1,'REAR_DERAILLEUR','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,21,1,'PULLEY_UPPER','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,22,1,'PULLEY_LOWER','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,23,1,'CRANKSET','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,24,1,'CHAINRING_OUTER','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,25,1,'CHAINRING_INNER','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,26,1,'BOTTOM_BRACKET','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,28,1,'CHAIN','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,29,1,'QUICK_LINK','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,30,1,'FRONT_BRAKE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,31,1,'REAR_BRAKE','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,32,1,'FRONT_PADS','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,33,1,'REAR_PADS','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(11,36,1,'BATTERY','2026-09-14T22:00:00Z',106.8,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,1,1,'FRAME','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,2,1,'FORK','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,17,1,'WHEELSET','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,5,1,'FRONT_WHEEL','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,7,1,'TIRE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,8,1,'TUBE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,34,1,'ROTOR','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,6,1,'REAR_WHEEL','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,9,1,'TIRE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,27,1,'CASSETTE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,35,1,'ROTOR','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,55,1,'TUBE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,18,1,'SHIFTERS','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,19,1,'FRONT_DERAILLEUR','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,20,1,'REAR_DERAILLEUR','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,21,1,'PULLEY_UPPER','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,22,1,'PULLEY_LOWER','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,23,1,'CRANKSET','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,24,1,'CHAINRING_OUTER','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,25,1,'CHAINRING_INNER','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,26,1,'BOTTOM_BRACKET','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,28,1,'CHAIN','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,29,1,'QUICK_LINK','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,30,1,'FRONT_BRAKE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,31,1,'REAR_BRAKE','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,32,1,'FRONT_PADS','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,33,1,'REAR_PADS','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(12,36,1,'BATTERY','2026-09-16T22:00:00Z',37.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,1,1,'FRAME','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,2,1,'FORK','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,17,1,'WHEELSET','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,5,1,'FRONT_WHEEL','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,7,1,'TIRE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,8,1,'TUBE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,34,1,'ROTOR','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,6,1,'REAR_WHEEL','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,9,1,'TIRE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,27,1,'CASSETTE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,35,1,'ROTOR','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,55,1,'TUBE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,18,1,'SHIFTERS','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,19,1,'FRONT_DERAILLEUR','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,20,1,'REAR_DERAILLEUR','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,21,1,'PULLEY_UPPER','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,22,1,'PULLEY_LOWER','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,23,1,'CRANKSET','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,24,1,'CHAINRING_OUTER','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,25,1,'CHAINRING_INNER','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,26,1,'BOTTOM_BRACKET','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,28,1,'CHAIN','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,29,1,'QUICK_LINK','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,30,1,'FRONT_BRAKE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,31,1,'REAR_BRAKE','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,32,1,'FRONT_PADS','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,33,1,'REAR_PADS','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(13,36,1,'BATTERY','2026-09-18T22:00:00Z',79.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,3,2,'FRAME','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,4,2,'FORK','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,11,2,'FRONT_WHEEL','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,13,2,'TIRE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,14,2,'TUBE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,51,2,'ROTOR','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,12,2,'REAR_WHEEL','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,15,2,'TIRE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,16,2,'TUBE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,44,2,'CASSETTE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,52,2,'ROTOR','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,37,2,'SHIFTERS','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,38,2,'REAR_DERAILLEUR','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,39,2,'PULLEY_UPPER','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,40,2,'PULLEY_LOWER','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,41,2,'CRANKSET','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,42,2,'CHAINRING_OUTER','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,43,2,'BOTTOM_BRACKET','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,45,2,'CHAIN','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,46,2,'QUICK_LINK','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,47,2,'FRONT_BRAKE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,48,2,'REAR_BRAKE','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,49,2,'FRONT_PADS','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,50,2,'REAR_PADS','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,53,2,'SHIFT_CABLE_REAR','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(14,54,2,'SHIFT_HOUSING_REAR','2026-09-19T22:00:00Z',47.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,1,1,'FRAME','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,2,1,'FORK','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,17,1,'WHEELSET','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,5,1,'FRONT_WHEEL','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,7,1,'TIRE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,8,1,'TUBE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,34,1,'ROTOR','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,6,1,'REAR_WHEEL','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,9,1,'TIRE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,27,1,'CASSETTE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,35,1,'ROTOR','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,55,1,'TUBE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,18,1,'SHIFTERS','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,19,1,'FRONT_DERAILLEUR','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,20,1,'REAR_DERAILLEUR','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,21,1,'PULLEY_UPPER','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,22,1,'PULLEY_LOWER','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,23,1,'CRANKSET','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,24,1,'CHAINRING_OUTER','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,25,1,'CHAINRING_INNER','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,26,1,'BOTTOM_BRACKET','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,28,1,'CHAIN','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,29,1,'QUICK_LINK','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,30,1,'FRONT_BRAKE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,31,1,'REAR_BRAKE','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,32,1,'FRONT_PADS','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,33,1,'REAR_PADS','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(15,36,1,'BATTERY','2026-09-21T22:00:00Z',92.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,1,1,'FRAME','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,2,1,'FORK','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,17,1,'WHEELSET','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,5,1,'FRONT_WHEEL','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,7,1,'TIRE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,8,1,'TUBE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,34,1,'ROTOR','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,6,1,'REAR_WHEEL','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,9,1,'TIRE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,27,1,'CASSETTE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,35,1,'ROTOR','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,55,1,'TUBE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,18,1,'SHIFTERS','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,19,1,'FRONT_DERAILLEUR','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,20,1,'REAR_DERAILLEUR','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,21,1,'PULLEY_UPPER','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,22,1,'PULLEY_LOWER','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,23,1,'CRANKSET','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,24,1,'CHAINRING_OUTER','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,25,1,'CHAINRING_INNER','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,26,1,'BOTTOM_BRACKET','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,28,1,'CHAIN','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,29,1,'QUICK_LINK','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,30,1,'FRONT_BRAKE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,31,1,'REAR_BRAKE','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,32,1,'FRONT_PADS','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,33,1,'REAR_PADS','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(16,36,1,'BATTERY','2026-09-23T22:00:00Z',81.6,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,1,1,'FRAME','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,2,1,'FORK','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,17,1,'WHEELSET','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,5,1,'FRONT_WHEEL','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,7,1,'TIRE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,8,1,'TUBE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,34,1,'ROTOR','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,6,1,'REAR_WHEEL','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,9,1,'TIRE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,27,1,'CASSETTE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,35,1,'ROTOR','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,55,1,'TUBE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,18,1,'SHIFTERS','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,19,1,'FRONT_DERAILLEUR','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,20,1,'REAR_DERAILLEUR','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,21,1,'PULLEY_UPPER','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,22,1,'PULLEY_LOWER','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,23,1,'CRANKSET','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,24,1,'CHAINRING_OUTER','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,25,1,'CHAINRING_INNER','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,26,1,'BOTTOM_BRACKET','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,28,1,'CHAIN','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,29,1,'QUICK_LINK','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,30,1,'FRONT_BRAKE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,31,1,'REAR_BRAKE','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,32,1,'FRONT_PADS','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,33,1,'REAR_PADS','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(17,36,1,'BATTERY','2026-09-25T22:00:00Z',52.2,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,3,2,'FRAME','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,4,2,'FORK','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,11,2,'FRONT_WHEEL','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,13,2,'TIRE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,14,2,'TUBE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,51,2,'ROTOR','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,12,2,'REAR_WHEEL','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,15,2,'TIRE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,16,2,'TUBE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,44,2,'CASSETTE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,52,2,'ROTOR','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,37,2,'SHIFTERS','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,38,2,'REAR_DERAILLEUR','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,39,2,'PULLEY_UPPER','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,40,2,'PULLEY_LOWER','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,41,2,'CRANKSET','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,42,2,'CHAINRING_OUTER','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,43,2,'BOTTOM_BRACKET','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,45,2,'CHAIN','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,46,2,'QUICK_LINK','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,47,2,'FRONT_BRAKE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,48,2,'REAR_BRAKE','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,49,2,'FRONT_PADS','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,50,2,'REAR_PADS','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,53,2,'SHIFT_CABLE_REAR','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(18,54,2,'SHIFT_HOUSING_REAR','2026-09-26T22:00:00Z',84.1,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,1,1,'FRAME','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,2,1,'FORK','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,18,1,'SHIFTERS','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,19,1,'FRONT_DERAILLEUR','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,20,1,'REAR_DERAILLEUR','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,21,1,'PULLEY_UPPER','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,22,1,'PULLEY_LOWER','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,23,1,'CRANKSET','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,24,1,'CHAINRING_OUTER','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,25,1,'CHAINRING_INNER','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,26,1,'BOTTOM_BRACKET','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,28,1,'CHAIN','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,29,1,'QUICK_LINK','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,30,1,'FRONT_BRAKE','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,31,1,'REAR_BRAKE','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(19,36,1,'BATTERY','2026-10-01T16:30:00Z',35.4,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,1,1,'FRAME','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,2,1,'FORK','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,17,1,'WHEELSET','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,5,1,'FRONT_WHEEL','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,7,1,'TIRE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,8,1,'TUBE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,34,1,'ROTOR','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,6,1,'REAR_WHEEL','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,9,1,'TIRE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,27,1,'CASSETTE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,35,1,'ROTOR','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,55,1,'TUBE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,18,1,'SHIFTERS','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,19,1,'FRONT_DERAILLEUR','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,20,1,'REAR_DERAILLEUR','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,21,1,'PULLEY_UPPER','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,22,1,'PULLEY_LOWER','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,23,1,'CRANKSET','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,24,1,'CHAINRING_OUTER','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,25,1,'CHAINRING_INNER','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,26,1,'BOTTOM_BRACKET','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,28,1,'CHAIN','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,29,1,'QUICK_LINK','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,30,1,'FRONT_BRAKE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,31,1,'REAR_BRAKE','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,32,1,'FRONT_PADS','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,33,1,'REAR_PADS','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(20,36,1,'BATTERY','2026-10-02T22:00:00Z',77.3,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,1,1,'FRAME','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,2,1,'FORK','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,17,1,'WHEELSET','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,5,1,'FRONT_WHEEL','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,7,1,'TIRE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,8,1,'TUBE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,34,1,'ROTOR','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,6,1,'REAR_WHEEL','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,9,1,'TIRE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,27,1,'CASSETTE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,35,1,'ROTOR','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,55,1,'TUBE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,18,1,'SHIFTERS','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,19,1,'FRONT_DERAILLEUR','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,20,1,'REAR_DERAILLEUR','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,21,1,'PULLEY_UPPER','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,22,1,'PULLEY_LOWER','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,23,1,'CRANKSET','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,24,1,'CHAINRING_OUTER','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,25,1,'CHAINRING_INNER','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,26,1,'BOTTOM_BRACKET','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,28,1,'CHAIN','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,29,1,'QUICK_LINK','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,30,1,'FRONT_BRAKE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,31,1,'REAR_BRAKE','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,32,1,'FRONT_PADS','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,33,1,'REAR_PADS','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(21,36,1,'BATTERY','2026-10-05T22:00:00Z',112.9,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,1,1,'FRAME','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,2,1,'FORK','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,17,1,'WHEELSET','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,5,1,'FRONT_WHEEL','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,7,1,'TIRE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,8,1,'TUBE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,34,1,'ROTOR','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,6,1,'REAR_WHEEL','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,9,1,'TIRE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,27,1,'CASSETTE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,35,1,'ROTOR','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,55,1,'TUBE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,18,1,'SHIFTERS','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,19,1,'FRONT_DERAILLEUR','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,20,1,'REAR_DERAILLEUR','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,21,1,'PULLEY_UPPER','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,22,1,'PULLEY_LOWER','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,23,1,'CRANKSET','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,24,1,'CHAINRING_OUTER','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,25,1,'CHAINRING_INNER','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,26,1,'BOTTOM_BRACKET','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,28,1,'CHAIN','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,29,1,'QUICK_LINK','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,30,1,'FRONT_BRAKE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,31,1,'REAR_BRAKE','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,32,1,'FRONT_PADS','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,33,1,'REAR_PADS','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(22,36,1,'BATTERY','2026-10-07T22:00:00Z',57.0,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,1,1,'FRAME','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,2,1,'FORK','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,17,1,'WHEELSET','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,5,1,'FRONT_WHEEL','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,7,1,'TIRE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,8,1,'TUBE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,34,1,'ROTOR','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,6,1,'REAR_WHEEL','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,9,1,'TIRE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,27,1,'CASSETTE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,35,1,'ROTOR','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,55,1,'TUBE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,18,1,'SHIFTERS','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,19,1,'FRONT_DERAILLEUR','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,20,1,'REAR_DERAILLEUR','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,21,1,'PULLEY_UPPER','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,22,1,'PULLEY_LOWER','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,23,1,'CRANKSET','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,24,1,'CHAINRING_OUTER','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,25,1,'CHAINRING_INNER','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,26,1,'BOTTOM_BRACKET','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,28,1,'CHAIN','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,29,1,'QUICK_LINK','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,30,1,'FRONT_BRAKE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,31,1,'REAR_BRAKE','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,32,1,'FRONT_PADS','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,33,1,'REAR_PADS','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(23,36,1,'BATTERY','2026-10-09T22:00:00Z',40.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,3,2,'FRAME','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,4,2,'FORK','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,11,2,'FRONT_WHEEL','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,13,2,'TIRE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,14,2,'TUBE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,51,2,'ROTOR','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,12,2,'REAR_WHEEL','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,15,2,'TIRE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,16,2,'TUBE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,44,2,'CASSETTE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,52,2,'ROTOR','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,37,2,'SHIFTERS','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,38,2,'REAR_DERAILLEUR','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,39,2,'PULLEY_UPPER','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,40,2,'PULLEY_LOWER','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,41,2,'CRANKSET','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,42,2,'CHAINRING_OUTER','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,43,2,'BOTTOM_BRACKET','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,45,2,'CHAIN','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,46,2,'QUICK_LINK','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,47,2,'FRONT_BRAKE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,48,2,'REAR_BRAKE','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,49,2,'FRONT_PADS','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,50,2,'REAR_PADS','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,53,2,'SHIFT_CABLE_REAR','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(24,54,2,'SHIFT_HOUSING_REAR','2026-10-10T22:00:00Z',49.7,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,1,1,'FRAME','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,2,1,'FORK','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,17,1,'WHEELSET','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,5,1,'FRONT_WHEEL','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,7,1,'TIRE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,8,1,'TUBE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,34,1,'ROTOR','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,6,1,'REAR_WHEEL','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,9,1,'TIRE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,27,1,'CASSETTE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,35,1,'ROTOR','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,55,1,'TUBE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,18,1,'SHIFTERS','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,19,1,'FRONT_DERAILLEUR','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,20,1,'REAR_DERAILLEUR','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,21,1,'PULLEY_UPPER','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,22,1,'PULLEY_LOWER','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,23,1,'CRANKSET','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,24,1,'CHAINRING_OUTER','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,25,1,'CHAINRING_INNER','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,26,1,'BOTTOM_BRACKET','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,28,1,'CHAIN','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,29,1,'QUICK_LINK','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,30,1,'FRONT_BRAKE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,31,1,'REAR_BRAKE','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,32,1,'FRONT_PADS','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,33,1,'REAR_PADS','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(25,36,1,'BATTERY','2026-10-14T22:00:00Z',81.5,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,1,1,'FRAME','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,2,1,'FORK','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,18,1,'SHIFTERS','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,19,1,'FRONT_DERAILLEUR','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,20,1,'REAR_DERAILLEUR','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,21,1,'PULLEY_UPPER','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,22,1,'PULLEY_LOWER','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,23,1,'CRANKSET','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,24,1,'CHAINRING_OUTER','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,25,1,'CHAINRING_INNER','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,26,1,'BOTTOM_BRACKET','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,28,1,'CHAIN','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,29,1,'QUICK_LINK','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,30,1,'FRONT_BRAKE','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,31,1,'REAR_BRAKE','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(26,36,1,'BATTERY','2026-10-17T16:30:00Z',25.7,3600,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,3,2,'FRAME','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,4,2,'FORK','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,11,2,'FRONT_WHEEL','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,13,2,'TIRE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,14,2,'TUBE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,51,2,'ROTOR','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,12,2,'REAR_WHEEL','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,15,2,'TIRE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,16,2,'TUBE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,44,2,'CASSETTE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,52,2,'ROTOR','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,37,2,'SHIFTERS','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,38,2,'REAR_DERAILLEUR','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,39,2,'PULLEY_UPPER','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,40,2,'PULLEY_LOWER','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,41,2,'CRANKSET','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,42,2,'CHAINRING_OUTER','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,43,2,'BOTTOM_BRACKET','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,45,2,'CHAIN','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,46,2,'QUICK_LINK','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,47,2,'FRONT_BRAKE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,48,2,'REAR_BRAKE','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,49,2,'FRONT_PADS','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,50,2,'REAR_PADS','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,53,2,'SHIFT_CABLE_REAR','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
INSERT INTO "usage_contribution" VALUES(27,54,2,'SHIFT_HOUSING_REAR','2026-10-17T22:00:00Z',53.4,NULL,'HISTORY',1,'COUNTED',NULL);
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
INSERT INTO "usage_profile" VALUES(1,'4cfb89d1-34e6-4e19-b096-a1e1a286fd92','OUTDOOR','Outdoor','OUTDOOR','[]','[]','');
INSERT INTO "usage_profile" VALUES(2,'d212636d-e8ad-4e4f-bbcf-985f4e81607b','DIRECT_DRIVE_TRAINER','Direct-drive trainer (wheels off)','TRAINER','["WHEELSET", "FRONT_WHEEL", "REAR_WHEEL", "CASSETTE"]','["BRAKE_PADS", "TIRE", "BRAKE_ROTOR"]','Rear wheel and cassette are removed; the trainer has its own cassette. Front wheel, tires, rotors and pads do not wear.');
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
INSERT INTO "work_session" VALUES(1,'cfac354a-6c31-4eb5-a222-dc0e55b55b25','2026-08-19','2026-08-19',1,'Ultegra Di2 groupset',NULL,'2026-11-14T18:52:47Z',NULL,NULL);
INSERT INTO "work_session" VALUES(2,'2422a60f-7ed0-4bb7-8a6f-a208070a4aeb','2026-08-19','2026-08-19',2,'GRX 1×12 groupset',NULL,'2026-11-14T18:52:48Z',NULL,NULL);
CREATE INDEX ix_import_batch_file_sha256 ON import_batch (file_sha256);
CREATE INDEX ix_component_component_type ON component (component_type);
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
CREATE TRIGGER trg_component_no_delete BEFORE DELETE ON component
    WHEN EXISTS (SELECT 1 FROM installation WHERE component_id = OLD.id)
      OR EXISTS (SELECT 1 FROM maintenance_event WHERE component_id = OLD.id)
      OR EXISTS (SELECT 1 FROM usage_contribution WHERE component_id = OLD.id)
    BEGIN
        SELECT RAISE(ABORT, 'PROTECTED: component has history; retire it instead');
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
CREATE TRIGGER trg_component_tire_setup_insert BEFORE INSERT ON component
            FOR EACH ROW WHEN NEW.tire_setup IS NOT NULL AND NEW.tire_setup NOT IN ('TUBE','TUBELESS','TUBULAR')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component.tire_setup must be TUBE, TUBELESS or TUBULAR'); END;
CREATE TRIGGER trg_component_tire_setup_update BEFORE UPDATE ON component
            FOR EACH ROW WHEN NEW.tire_setup IS NOT NULL AND NEW.tire_setup NOT IN ('TUBE','TUBELESS','TUBULAR')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component.tire_setup must be TUBE, TUBELESS or TUBULAR'); END;
CREATE INDEX ix_change_log_bike_id ON change_log (bike_id);
CREATE INDEX ix_change_log_component_id ON change_log (component_id);
CREATE TRIGGER trg_change_log_no_delete BEFORE DELETE ON change_log
    BEGIN SELECT RAISE(ABORT, 'PROTECTED: the change log cannot be deleted'); END;
CREATE TRIGGER trg_change_log_no_update BEFORE UPDATE ON change_log
    BEGIN SELECT RAISE(ABORT, 'PROTECTED: the change log cannot be changed'); END;
CREATE INDEX ix_component_bundle_id ON component (bundle_id);
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
CREATE TRIGGER trg_component_disposition_insert BEFORE INSERT ON component
            FOR EACH ROW WHEN NEW.disposition NOT IN ('STORED','AWAITING_SERVICE','RETIRED','DISCARDED','SOLD','VOIDED','IN_USE','WARRANTY_RETURN')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component.disposition must be one of (STORED,AWAITING_SERVICE,RETIRED,DISCARDED,SOLD,VOIDED,IN_USE,WARRANTY_RETURN)'); END;
CREATE TRIGGER trg_component_disposition_update BEFORE UPDATE ON component
            FOR EACH ROW WHEN NEW.disposition NOT IN ('STORED','AWAITING_SERVICE','RETIRED','DISCARDED','SOLD','VOIDED','IN_USE','WARRANTY_RETURN')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component.disposition must be one of (STORED,AWAITING_SERVICE,RETIRED,DISCARDED,SOLD,VOIDED,IN_USE,WARRANTY_RETURN)'); END;
CREATE TRIGGER trg_component_disposition_disposition_insert BEFORE INSERT ON component_disposition
            FOR EACH ROW WHEN NEW.disposition NOT IN ('STORED','AWAITING_SERVICE','RETIRED','DISCARDED','SOLD','VOIDED','IN_USE','WARRANTY_RETURN')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component_disposition.disposition must be one of (STORED,AWAITING_SERVICE,RETIRED,DISCARDED,SOLD,VOIDED,IN_USE,WARRANTY_RETURN)'); END;
CREATE TRIGGER trg_component_disposition_disposition_update BEFORE UPDATE ON component_disposition
            FOR EACH ROW WHEN NEW.disposition NOT IN ('STORED','AWAITING_SERVICE','RETIRED','DISCARDED','SOLD','VOIDED','IN_USE','WARRANTY_RETURN')
            BEGIN SELECT RAISE(ABORT, 'INVALID: component_disposition.disposition must be one of (STORED,AWAITING_SERVICE,RETIRED,DISCARDED,SOLD,VOIDED,IN_USE,WARRANTY_RETURN)'); END;
COMMIT;
