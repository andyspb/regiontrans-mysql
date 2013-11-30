
-- 'accountview_all', 'accountview' 16 +
 
INSERT INTO `severtrans`.`guiview` VALUES (27, 'Счета', 'AccountView_all');
insert into `severtrans`.`guiheader` values (27, 'Account_all', '+', '', 27);
insert into `severtrans`.`guifield` values (317, 'Номер', 'Number', 0, 0, '', 1, 27);
insert into `severtrans`.`guifield` values (318, 'Дата составления', 'Dat', 0, 0, '', 2, 27);
insert into `severtrans`.`guifield` values (319, 'Заказчик', 'ClientName', 0, 0, '', 1, 27);
insert into `severtrans`.`guifield` values (320, 'Сумма с НДС', 'SumNDS', 0, 0, '', 1, 27);
 
-- 'accounttekview_all', 'accounttekview' 22 +

INSERT INTO `severtrans`.`guiview` VALUES (28, 'Картотека Счета-ТЭК', 'Accounttekview_all');
insert into `severtrans`.`guiheader` values (28, 'Accounttekview_all', '+', '', 28);
insert into `severtrans`.`guifield` values (321, 'Клиент', 'Client_Acronym', 0, 0, '', 1, 28);
insert into `severtrans`.`guifield` values (322, 'Номер', 'Number', 0, 0, '', 1, 28);
insert into `severtrans`.`guifield` values (323, 'Дата', 'Dat', 0, 0, '', 2, 28);
insert into `severtrans`.`guifield` values (324, 'Сумма', 'Sum', 0, 0, '', 1, 28);

-- 'akttekview_all', 'akttekview' 21 + Done !!!

INSERT INTO `severtrans`.`guiview` VALUES (26, 'Картотека Акты-ТЭК', 'Akttekview_all');
insert into `severtrans`.`guiheader` values (26, 'Akttekview_all', '+', '',26);
insert into `severtrans`.`guifield` values (312, 'Клиент', 'Client_Acronym', 0, 0, '', 1, 26);
insert into `severtrans`.`guifield` values (313, 'Номер', 'Number', 0, 0, '', 1, 26);
insert into `severtrans`.`guifield` values (314, 'Дата', 'Data', 0, 0, '', 2, 26);
insert into `severtrans`.`guifield` values (315, 'Сумма', 'Sum', 0, 0, '', 1, 26);
insert into `severtrans`.`guifield` values (316, 'Возврат акта', 'Reportreturn', 0, 0, '', 1, 26);

-- 'invoiceview_all', 'invoiceview' 17 +

INSERT INTO `severtrans`.`guiview` VALUES (29, 'Счет фактуры', 'InvoiceView_all');
insert into `severtrans`.`guiheader` values (29, 'InvoiceView_all', '+', '', 29);
insert into `severtrans`.`guifield` values (325, 'Дата', 'Data', 0, 0, '', 2, 29);
insert into `severtrans`.`guifield` values (326, 'Номер', 'Number', 0, 0, '', 1, 29);
insert into `severtrans`.`guifield` values (327, 'Заказчик', 'Acronym', 0, 0, '', 1, 29);
insert into `severtrans`.`guifield` values (328, 'Сумма', 'Sum', 0, 0, '', 1, 29);
insert into `severtrans`.`guifield` values (329, 'НДС', 'NDS', 0, 0, '', 1, 29);
insert into `severtrans`.`guifield` values (330, 'Вознагр. агента', 'Fee', 0, 0, '', 1, 29);
insert into `severtrans`.`guifield` values (331, 'Возврат акта', 'ReportReturnName', 0, 0, '', 1, 29);
 
-- 'orders_all', 'orders' 15 +
INSERT INTO `severtrans`.`guiview` VALUES (30, 'Приходные ордера', 'Orders_all');
insert into `severtrans`.`guiheader` values (30, 'Orders_all', '+', '', 30);
insert into `severtrans`.`guifield` values (332, 'Клиент', 'ClientsName', 0, 0, '', 1, 30);
insert into `severtrans`.`guifield` values (333, 'Номер', 'Number', 0, 0, '', 1, 30);
insert into `severtrans`.`guifield` values (334, 'Дата', 'Dat', 0, 0, '', 2, 30);
insert into `severtrans`.`guifield` values (335, 'Сумма', 'Sum', 0, 0, '', 1, 30);
insert into `severtrans`.`guifield` values (336, 'НДС', 'NDS', 0, 0, '', 1, 30);
insert into `severtrans`.`guifield` values (337, 'Сумма с НДС', 'SumNDS', 0, 0, '', 1, 30);
 
 'orderstek_all', 'orderstek' ???

-- 'paysheetview_all', 'paysheetview' 18 +
INSERT INTO `severtrans`.`guiview` VALUES (31, 'Платежки', 'PaySheetView_all');
insert into `severtrans`.`guiheader` values (31, 'PaySheetView_all', '+', '', 31);
insert into `severtrans`.`guifield` values (338, 'Клиент', 'Acronym', 0, 0, '', 1, 31);
insert into `severtrans`.`guifield` values (339, 'Номер', 'Number', 0, 0, '', 1, 31);
insert into `severtrans`.`guifield` values (340, 'Дата', 'Dat', 0, 0, '', 2, 31);
insert into `severtrans`.`guifield` values (341, 'Сумма', 'Sum', 0, 0, '', 1, 31);
 
-- 'sends_all', 'sends' 12 +
INSERT INTO `severtrans`.`guiview` VALUES (32, 'Отправки', 'Sends_all');
insert into `severtrans`.`guiheader` values (32, 'Sends_all', '+', '', 32);
insert into `severtrans`.`guifield` values (342, 'Заказчик', 'ClientAcr', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (343, 'Отправитель', 'ClientSenderAcr', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (344, 'Получатель', 'AcceptorName', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (345, 'Пункт назначения', 'CityName', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (346, 'Номер', 'Namber', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (347, 'Дата составления', 'Start', 0, 0, '', 2, 32);
insert into `severtrans`.`guifield` values (348, 'Оператор', 'PeopleFIO', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (349, 'Тип перевозки', 'ContracttypeName', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (350, 'Тип оплаты', 'PayTypeName', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (351, 'Дата отправл.', 'DateSend', 0, 0, '', 2, 32);
insert into `severtrans`.`guifield` values (352, 'Экспедитор', 'Forwarder', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (353, 'Выгрузка силами', 'RollOutName', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (354, 'Наимен. груза', 'NameGoodName', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (355, 'Вес', 'Weight', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (356, 'Объем', 'Volume', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (357, 'Расчет. вес', 'CountWeight', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (358, 'Тариф', 'Tariff', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (359, 'Провозн. плата', 'Fare', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (360, 'Упаковка', 'PackTarif', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (361, 'Доп. услуги', 'AddServicePrace', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (362, 'N Акта-ТЕК', 'AkttekNumber', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (363, 'Стараховая сумма', 'InsuranceSum', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (364, 'Процент страхования', 'InsurancePercent', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (365, 'Стоимость страховки', 'InsuranceValue', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (366, 'Итоговая сумма', 'SumCount', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (367, 'Количество мест', 'PlaceC', 0, 0, '', 0, 32);
insert into `severtrans`.`guifield` values (368, 'Номер СФ', 'NumberCountPattern', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (369, 'Состояние отпр.', 'SendTypeName', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (370, 'Дата доставки', 'DateSupp', 0, 0, '', 2, 32);
insert into `severtrans`.`guifield` values (371, 'Кем доставлена', 'SupplierName', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (372, 'Вид упаковки', 'PackCount', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (373, 'Стоимость дороги', 'SumWay', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (374, '№ счета (дороги)', 'NumberWay', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (375, 'Стоимость услуг', 'SumServ', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (376, '№ счета (услуги)', 'NumberServ', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (377, 'Вес (жд)', 'WeightGd', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (378, 'Вид упаковки (жд)', 'PlaceGd', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (379, '№ п/п', 'NumberPP', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (380, 'Тип оплаты за догрогу', 'WayName', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (381, 'Тип оплаты за услуги', 'ServName', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (382, 'Название доп/усл', 'AddServStr', 0, 0, '', 1, 32);
insert into `severtrans`.`guifield` values (383, 'Сумма за доп/усл', 'AddServSum', 0, 0, '', 1, 32);


 
 'svpayreceipt_all', 'svpayreceipt'
 'vs1_all', 'vs1'
 'vs2_all', 'vs2'

