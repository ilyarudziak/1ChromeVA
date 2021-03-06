﻿&НаКлиенте
Перем Протокол, ИдентификаторКомпоненты, ВнешняяКомпонента;

&НаСервереБезКонтекста
Функция ПрочитатьСтрокуJSON(ТекстJSON, ПрочитатьВСоответствие = Ложь)
	
	Если ПустаяСтрока(ТекстJSON) Тогда
		Возврат Новый Структура;
	КонецЕсли;

	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(ТекстJSON);
	Возврат ПрочитатьJSON(ЧтениеJSON, ПрочитатьВСоответствие);
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаписатьСтрокуJSON(ДанныеJSON)
	
	ЗаписьJSON = новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, ДанныеJSON);
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МакетКомпоненты = ОбработкаОбъект.ПолучитьМакет("VA_1cWinCtrl");
	Объект.component = ПоместитьВоВременноеХранилище(МакетКомпоненты, УникальныйИдентификатор);
	Объект.javascript = ОбработкаОбъект.ПолучитьМакет("VA_JavaScript").ПолучитьТекст();
	
	Объект.URL = "http://infostart.ru";
	Объект.port = 9222;
	Объект.domain = "Runtime";
	
	ТекстJavaScript = "$('#journal-header .journal-info').text()";
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключениеВнешнейКомпоненты(ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеВнешнейКомпонентыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, Объект.component, ИдентификаторКомпоненты, ТипВнешнейКомпоненты.Native); 
	
КонецПроцедуры	

&НаКлиенте
Процедура ПодключениеВнешнейКомпонентыЗавершение(Подключение, ДополнительныеПараметры) Экспорт
	
	Если Подключение Тогда
		ВнешняяКомпонента = Новый("AddIn." + ИдентификаторКомпоненты + ".WindowsControl");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолученаВерсияКомпоненты", ЭтотОбъект);
		ВнешняяКомпонента.НачатьПолучениеВерсия(ОписаниеОповещения);
	ИначеЕсли ДополнительныеПараметры = Истина Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключениеВнешнейКомпоненты", ЭтотОбъект, Ложь);
		НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, Объект.component);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПолученаВерсияКомпоненты(Значение, ДополнительныеПараметры) Экспорт
	
	Заголовок = "Chrome DevTools protocol, version " + Значение;
	
КонецПроцедуры	

#Если ВебКлиент Тогда
	
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьКоманды(Команды.ЗаполнитьОписание);
	
КонецПроцедуры	
	
#Иначе
	
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИдентификаторКомпоненты = "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	ВыполнитьПодключениеВнешнейКомпоненты(Истина);
	
	#Если ТонкийКлиент Тогда
	СисИнфо = Новый СистемнаяИнформация;
	Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 
		ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Shell = Новый COMОбъект("WScript.Shell");
	    ProgramFiles = Shell.ExpandEnvironmentStrings("%ProgramFiles%");   	
		ИмяФайла = "\Google\Chrome\Application\chrome.exe";
		Файл = Новый Файл(ProgramFiles + ИмяФайла);
		ДополнительныеПараметры = новый Структура("ПолноеИмя,Продолжать", Файл.ПолноеИмя, Истина);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверкаСуществованияФайла", ЭтотОбъект, ДополнительныеПараметры);
		Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

#КонецЕсли		

&НаКлиенте
Процедура ПроверкаСуществованияФайла(Существует, ДополнительныеПараметры) Экспорт
	
	Если Существует Тогда
		Объект.browser = ДополнительныеПараметры.ПолноеИмя;
	ИначеЕсли ДополнительныеПараметры.Свойство("Продолжать") Тогда
		Shell = Новый COMОбъект("WScript.Shell");
	    ProgramFiles = Shell.ExpandEnvironmentStrings("%ProgramFiles(x86)%");   	
		ИмяФайла = "\Google\Chrome\Application\chrome.exe";
		Файл = Новый Файл(ProgramFiles + ИмяФайла);
		ДополнительныеПараметры = новый Структура("ПолноеИмя", Файл.ПолноеИмя);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверкаСуществованияФайла", ЭтотОбъект, ДополнительныеПараметры);
		Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	Иначе
		Сообщить("Не найден исполняемый файл Google Chrome");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаголовокКоманды(ИмяКоманды)
	
	Возврат Команды.Найти(ИмяКоманды).Заголовок;
	
КонецФункции	

&НаКлиенте
Процедура ОшибкаБраузера(Команда)
	
	ИнформационныйТекст = 
	"Перед вызовом команды «" + ЗаголовокКоманды(Команда.Имя) + "»
	|закройте все открытые окна Google Chrome
	|и запустите снова кнопкой «Запустить браузер».";
	ПоказатьПредупреждение(, ИнформационныйТекст, 10);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьБраузер(Команда)
	
	СтрокаКоманды = """" + Объект.browser + """ about:blank --remote-debugging-port=" + Формат(Объект.port, "ЧГ=");
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗапущенБраузер", ЭтотОбъект);
	НачатьЗапускПриложения(ОписаниеОповещения, СтрокаКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапущенБраузер(КодВозврата, ДополнительныеПараметры) Экспорт
	
	// Ничего не делаем
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОписаниеПротокола()
	
	HTTPЗапрос = Новый HTTPЗапрос("/json/protocol");
	HTTPСоединение = Новый HTTPСоединение("localhost", 9222, , , , 10);
	HTTPОтвет = HTTPСоединение.Получить(HTTPЗапрос);
	
	ТекстJSON = HTTPОтвет.ПолучитьТелоКакСтроку();
	Возврат ПрочитатьСтрокуJSON(ТекстJSON, Истина);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьКоманды(Команда)
	
	Попытка
		Протокол = ПолучитьОписаниеПротокола();
	Исключение
		ОшибкаБраузера(Команда);
		Возврат;
	КонецПопытки;
	
	СписокВыбора = Элементы.Домен.СписокВыбора;
	СписокВыбора.Очистить();
	Для каждого Элемент из Протокол.Получить("domains") Цикл
		СписокВыбора.Добавить(Элемент.Получить("domain"));
	КонецЦикла;
	СписокВыбора.СортироватьПоЗначению();
	ДоменПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьURL(Команда)
	
	HTTPЗапрос = Новый HTTPЗапрос("/json/new?" + Объект.URL);
	
	HTTPСоединение = Новый HTTPСоединение("localhost", 9222, , , , 10);

	Попытка
		HTTPОтвет = HTTPСоединение.Получить(HTTPЗапрос);
	Исключение
		ОшибкаБраузера(Команда);
		Возврат;
	КонецПопытки;
	
	ТекстJSON = HTTPОтвет.ПолучитьТелоКакСтроку();
	ДанныеJSON = ПрочитатьСтрокуJSON(ТекстJSON, Ложь);
	Объект.WS = ДанныеJSON.webSocketDebuggerUrl;
	
	HTTPЗапрос = Новый HTTPЗапрос("/json/protocol");
	HTTPСоединение = Новый HTTPСоединение("localhost", 9222, , , , 10);
	HTTPОтвет = HTTPСоединение.Получить(HTTPЗапрос);
	ТекстJSON = HTTPОтвет.ПолучитьТелоКакСтроку();
	Протокол = ПрочитатьСтрокуJSON(ТекстJSON, Истина);
	
	СписокВыбора = Элементы.Домен.СписокВыбора;
	СписокВыбора.Очистить();
	Для каждого Элемент из Протокол.Получить("domains") Цикл
		СписокВыбора.Добавить(Элемент.Получить("domain"));
	КонецЦикла;
	СписокВыбора.СортироватьПоЗначению();
	ДоменПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьВызовВебСокет(ОписаниеОповещения, ИмяМетода, ПараметрыМетода = Неопределено);
	
	Если ПустаяСтрока(Объект.WS) Тогда
		ИнформационныйТекст = 
		"Перед вызовом команды Chrome DevTools Protocol
		|установите соединение с браузером и откройте
		|интернет-страницу кнопкой «Открыть URL».";
		ПоказатьПредупреждение(, ИнформационныйТекст, 10);
	КонецЕсли;
	
	ДанныеJSON = Новый Структура("id,method,params", 1, ИмяМетода, ПараметрыМетода);
	ВнешняяКомпонента.НачатьВызовВебСокет(ОписаниеОповещения, Объект.WS, ЗаписатьСтрокуJSON(ДанныеJSON));
	
КонецПроцедуры	

&НаКлиенте
Процедура ПолучитьСнимокЭкрана(Команда)

	ОписаниеОповещения = Новый ОписаниеОповещения("ПолученСнимокЭкрана", ЭтотОбъект);
	НачатьВызовВебСокет(ОписаниеОповещения, "Page.captureScreenshot");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученСнимокЭкрана(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ДанныеJSON = ПрочитатьСтрокуJSON(РезультатВызова);
	Если ДанныеJSON.Свойство("result") Тогда
		ДвоичныеДанные = Base64Значение(ДанныеJSON.result.data);
		СнимокЭкрана = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаСнимокЭкрана;
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ФайлПриложенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбранФайлБраузера", ЭтотОбъект);
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Истина;
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранФайлБраузера(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ВыбранныеФайлы) = Тип("Массив") Тогда
		Для каждого ЭлементМассива из ВыбранныеФайлы Цикл
			Объект.browser = ЭлементМассива;
			Прервать;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоменПриИзменении(Элемент)
	
	КомандыБраузера.Очистить();
	Для каждого Элемент из Протокол.Получить("domains") Цикл
		Если Элемент.Получить("domain") = Объект.domain Тогда
			Для каждого ЭлементКоманда из Элемент.Получить("commands") Цикл
				Стр = КомандыБраузера.Добавить();
				Стр.name = ЭлементКоманда.Получить("name");
				Стр.description = ЭлементКоманда.Получить("description");
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	КомандыБраузера.Сортировать("name");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьТест(Команда)

	ПараметрыМетода = Новый Структура("expression", Объект.javascript);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполненТест", ЭтотОбъект);
	НачатьВызовВебСокет(ОписаниеОповещения, "Runtime.evaluate", ПараметрыМетода);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполненТест(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	// Ничего не делаем
	
КонецПроцедуры

&НаКлиенте
Процедура КомандыБраузераПриАктивизацииСтроки(Элемент)
	
	ПараметрыКоманды.Очистить();
	РезультатКоманды.Очистить();
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Для каждого ЭлементДомен из Протокол.Получить("domains") Цикл
		Если ЭлементДомен.Получить("domain") = Объект.domain Тогда
			Для каждого ЭлементКоманда из ЭлементДомен.Получить("commands") Цикл
				Если ЭлементКоманда.Получить("name") = Элемент.ТекущиеДанные.name Тогда
					МасивПараметров = ЭлементКоманда.Получить("parameters") ;
					Если МасивПараметров <> Неопределено Тогда
						Для каждого ЭлементПараметр из МасивПараметров Цикл
							Стр = ПараметрыКоманды.Добавить();
							Стр.name = ЭлементПараметр.Получить("name");
							Стр.description = ЭлементПараметр.Получить("description");
							Стр.optional = ЭлементПараметр.Получить("optional");
							Стр.type = ЭлементПараметр.Получить("type");
							Если ПустаяСтрока(Стр.type) Тогда 
								Стр.type = ЭлементПараметр.Получить("$ref");
							КонецЕсли
						КонецЦикла;
					КонецЕсли;
					МасивПараметров = ЭлементКоманда.Получить("returns") ;
					Если МасивПараметров <> Неопределено Тогда
						Для каждого ЭлементПараметр из МасивПараметров Цикл
							Стр = РезультатКоманды.Добавить();
							Стр.name = ЭлементПараметр.Получить("name");
							Стр.description = ЭлементПараметр.Получить("description");
							Стр.type = ЭлементПараметр.Получить("type");
							Если ПустаяСтрока(Стр.type) Тогда 
								Стр.type = ЭлементПараметр.Получить("$ref");
							КонецЕсли
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыКоманды.Сортировать("name");
	РезультатКоманды.Сортировать("name");
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьВБуферОбмена(Команда)
	
	Если ПустаяСтрока(СнимокЭкрана) Тогда Возврат КонецЕсли;
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(СнимокЭкрана);
	ВнешняяКомпонента.НачатьУстановкуКартинкаБуфераОбмена(, ДвоичныеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьТекстHTML(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолученДокументHTML", ЭтотОбъект);
	НачатьВызовВебСокет(ОписаниеОповещения, "DOM.getDocument");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученДокументHTML(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ДанныеJSON = ПрочитатьСтрокуJSON(РезультатВызова);
	Если ДанныеJSON.Свойство("result") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолученТекстHTML", ЭтотОбъект);
		ПараметрыМетода = Новый Структура("backendNodeId", ДанныеJSON.result.root.backendNodeId);
		НачатьВызовВебСокет(ОписаниеОповещения, "DOM.getOuterHTML", ПараметрыМетода);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученТекстHTML(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ДанныеJSON = ПрочитатьСтрокуJSON(РезультатВызова);
	Если ДанныеJSON.Свойство("result") Тогда
		ТекстHTML = ДанныеJSON.result.outerHTML;
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ВыполнитьJavaScript(Команда)
	
	ПараметрыМетода = Новый Структура("expression", ТекстJavaScript);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолученРезультатJavaScript", ЭтотОбъект);
	НачатьВызовВебСокет(ОписаниеОповещения, "Runtime.evaluate", ПараметрыМетода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученРезультатJavaScript(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	РезультатJavaScript.Очистить();
	
	ДанныеJSON = ПрочитатьСтрокуJSON(РезультатВызова);
	
	Если ДанныеJSON.Свойство("result") Тогда
		Для каждого КлючЗначение из ДанныеJSON.result.result Цикл
			Стр = РезультатJavaScript.Добавить();
			ЗаполнитьЗначенияСвойств(Стр, КлючЗначение);
		КонецЦикла;
	КонецЕсли;
	
	НаборЗначений = Неопределено;
	Если ДанныеJSON.Свойство("error", НаборЗначений) Тогда
		Для каждого КлючЗначение из НаборЗначений Цикл
			Стр = РезультатJavaScript.Добавить();
			ЗаполнитьЗначенияСвойств(Стр, КлючЗначение);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры
