classdef N2YOWebAPI < handle
    %SATWEBAPI Класс для работы с WEBAPI сайта n2yo.com
    %   URL: ссылка к API
    %   APIKey: ключ лицензии, получаемый после регистрации
    
    properties (Access = private)
        URL;
        APIKey;
        CategoryListFile;
    end
    
    methods
        function obj = N2YOWebAPI()
            obj.URL = load('N2YOSettings').URL;
            obj.APIKey = load('N2YOSettings').APIKey;
            obj.CategoryListFile = load('N2YOSettings').CategoryListFile;
        end
        
        function obj = set.URL(obj,url)
            %SetURL устанавливает URL-ссылку для доступа к API
            obj.URL = url;         
        end
        
        function obj = set.APIKey(obj,apiKey)
            %SetAPIKey устанавливает ключ для работы с API
            %   Ключ генерируется в личном кабинете N2YO после регистрации
            obj.APIKey = apiKey;
        end
        
        function obj = set.CategoryListFile(obj,categoryListFile)
            %SetAPIKey устанавливает файл со списком категорий
            obj.CategoryListFile = categoryListFile;
        end
        
        function obj = SetURL(obj,url)
            %SetURL устанавливает URL-ссылку для доступа к API
            obj.URL = url;         
        end
        
        function obj = SetAPIKey(obj,apiKey)
            %SetAPIKey устанавливает ключ для работы с API
            %   Ключ генерируется в личном кабинете N2YO после регистрации
            obj.APIKey = apiKey;
        end
        
        function obj = SetCategoryListFile(obj,categoryListFile)
            %SetAPIKey устанавливает файл со списком категорий
            obj.CategoryListFile = categoryListFile;
        end
        
        function obj = UpdateSettings(obj)
            %UpdateSettings обновляет файл с настройками
            URL = obj.URL;
            APIKey = obj.APIKey;
            CategoryListFile = obj.CategoryListFile;
            save('N2YOSettings','URL','APIKey','CategoryListFile');
        end
        
        function categories = GetListOfCategories(obj)
            %GetListOfCategories выводит список категорий объектов
            categories = load(CategoryListFile).categoryList;
        end
        
        function aboveObjects = GetAboveObjects(obj,observerLat,observerLng,...
                observerAlt,searchRadius,categoryID)
            %GET возвращает все объекты над положением наблюдателя в
            %заданном угловом радиусе
            %   Request: /above/{observer_lat}/{observer_lng}/{observer_alt}/{search_radius}/{category_id}
            %   observerLat широта наблюдателя (град)
            %   observerLng долгота наблюдателя (град)
            %   observerAlt высота наблюдателя (м)
            %   searchRadius радиус поиска объектов (град)
            %   categoryID категория объектов
            APIrequest = [obj.URL '/above/' num2str(observerLat) '/'...
                                         num2str(observerLng) '/'...
                                         num2str(observerAlt) '/'...
                                         num2str(searchRadius) '/'...
                                         num2str(categoryID)...
                                         '/&apiKey=' obj.APIKey];
            aboveObjects = webread(APIrequest);
        end
        
        function tle = GetTLE(obj,ID)
            %GET возвращает TLE объекта с заданным ID
            %   Request: /tle/{id}
            %   ID номер NORAD
            APIrequest = [obj.URL '/tle/' num2str(ID)...
                                         '/&apiKey=' obj.APIKey];
            tle = webread(APIrequest);
        end
        
        function satellitePositions = GetSatellitePositions(obj,ID,observerLat,observerLng,...
                observerAlt,seconds)
            %GET возвращает траекторию заданного объекта в виде
            %подспутниковой трассы, а также азимут и долготу относительно
            %положения наблюдателя
            %   Request:  /positions/{id}/{observer_lat}/{observer_lng}/{observer_alt}/{seconds}
            %   Входные параметры:
            %   ID номер NORAD
            %   observerLat широта наблюдателя (град)
            %   observerLng долгота наблюдателя (град)
            %   observerAlt высота наблюдателя (м)
            %   seconds число точек в траектории (1 точка = 1 секунда),
            %   максимум 300
            %   Выходные параметры:
            %   satid номер NORAD
            %   satname	имя объекта
            %   transactionscount число обращений к API с текущего APIKey
            %   satlatitude	широта подспутниковой точки (град)
            %   satlongitude долгота подспутниковой точки (град)
            %   azimuth	азимут относительно положения наблюдателя (град)
            %   elevation угол места относительно положения наб. (град)
            %   ra	угол прямого восхождения (град)
            %   dec	угол склонения (град)
            %   timestamp время (UTC)
            APIrequest = [obj.URL '/positions/' num2str(ID) '/'...
                                         num2str(observerLat) '/'...
                                         num2str(observerLng) '/'...
                                         num2str(observerAlt) '/'...
                                         num2str(seconds) '/'...
                                         '/&apiKey=' obj.APIKey];
            satellitePositions = webread(APIrequest);
        end
        
        function visualPass = GetVisualPasses(obj,ID,observerLat,observerLng,...
                observerAlt,days,minVisibility)
            %GET возвращает траекторию визуального пролета объекта
            %относительно положения наблюдателя
            %   Request:  /visualpasses/{id}/{observer_lat}/{observer_lng}/{observer_alt}/{days}/{min_visibility}
            %   Входные параметры:
            %   ID номер NORAD
            %   observerLat широта наблюдателя (град)
            %   observerLng долгота наблюдателя (град)
            %   observerAlt высота наблюдателя (м)
            %   days число дней для предсказания (макс. 10)
            %   minVisibility минимальное время наблюдения (сек)
            %   Выходные параметры:
            %   satid номер NORAD
            %   satname	имя объекта
            %   transactionscount число обращений к API с текущего APIKey
            %   passescount число пролетов
            %   startAz	азимут на начало пролета относительно положения
            %   наблюдателя (град)
            %   startAzCompass	азимут на начало пролета относительно
            %   положения наблюдателя по сторонам света (N, NE, E, SE, S,
            %   SW, W, NW)
            %   startEl	угол места на начало пролета относительно положения
            %   наблюдателя (град)
            %   startUTC время начала пролета (UTC)
            %   maxAz азимут в точке траектории с максимальным углом места
            %   относительно положения наблюдателя (град)
            %   maxAzCompass азимут в точке траектории с максимальным углом
            %   места относительно положения наблюдателя (N, NE, E, SE, S,
            %   SW, W, NW)
            %   maxEl максимальный угол места относительно положения
            %   наблюдателя (град)
            %   maxUTC	время для точки траектории с максимальным углом
            %   места относительно положения наблюдателя (UTC)
            %   endAz азимут на конец пролета относительно положения
            %   наблюдателя (град)
            %   endAzCompass азимут на конец пролета относительно
            %   положения наблюдателя по сторонам света (N, NE, E, SE, S,
            %   SW, W, NW)
            %   endEl угол места на конец пролета относительно положения
            %   наблюдателя (град)
            %   endUTC время конца пролета (UTC)
            %   mag	максимальная яркость объекта (10000 если
            %   невозможно определить)
            %   duration длительность пролета (сек)
            APIrequest = [obj.URL '/visualpasses/' num2str(ID) '/'...
                                         num2str(observerLat) '/'...
                                         num2str(observerLng) '/'...
                                         num2str(observerAlt) '/'...
                                         num2str(days) '/'...
                                         num2str(minVisibility) '/'...
                                         '/&apiKey=' obj.APIKey];
            visualPass = webread(APIrequest);
        end
    end
end

