////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package models
{
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.net.HTTPService;
	
	public class MyModel extends EventDispatcher
	{
		public function MyModel()
		{
		}
		
        public static const ARCHIVED:String = " (Archived)";
        
        private var _configService:HTTPService;
        
        public function get configService():HTTPService
        {
            return _configService;
        }
        
        public function set configService(value:HTTPService):void
        {
            if (value != _configService)
            {
                _configService = value;
                _configService.addEventListener(HTTPService.EVENT_COMPLETE, completeHandler);
                dispatchEvent(new Event("configServiceChanged"));
            }
        }
        
        private var _reporterService:HTTPService;
        
        public function get reporterService():HTTPService
        {
            return _reporterService;
        }
        
        public function set reporterService(value:HTTPService):void
        {
            if (value != _reporterService)
            {
                _reporterService = value;
                _reporterService.addEventListener(HTTPService.EVENT_COMPLETE, reporterCompleteHandler);
                dispatchEvent(new Event("reporterServiceChanged"));
            }
        }
        
        private var _releaseService:HTTPService;
        
        public function get releaseService():HTTPService
        {
            return _releaseService;
        }
        
        public function set releaseService(value:HTTPService):void
        {
            if (value != _releaseService)
            {
                _releaseService = value;
                dispatchEvent(new Event("releaseServiceChanged"));
            }
        }
        
		private var _projectName:String;
		
        [Bindable("projectNameChanged")]
		public function get projectName():String
		{
			return _projectName;
		}
		
		public function set projectName(value:String):void
		{
			if (value != _projectName)
			{
                _projectName = value;
				dispatchEvent(new Event("projectNameChanged"));
			}
		}
		
        private var _projectTitle:String;
        
        [Bindable("projectTitleChanged")]
        public function get projectTitle():String
        {
            return _projectTitle;
        }
        
        public function set projectTitle(value:String):void
        {
            if (value != _projectTitle)
            {
                _projectTitle = value;
                dispatchEvent(new Event("projectTitleChanged"));
            }
        }
        
        private var _projectIcon:String;
        
        [Bindable("projectIconChanged")]
        public function get projectIcon():String
        {
            return _projectIcon;
        }
        
        public function set projectIcon(value:String):void
        {
            if (value != _projectIcon)
            {
                _projectIcon = value;
                dispatchEvent(new Event("projectIconChanged"));
            }
        }
        
		private var _issueCounterURL:String;
		
		[Bindable("issueCounterURLChanged")]
		public function get issueCounterURL():String
		{
			if (_issueCounterURL == null)
				return "";
			return _issueCounterURL;
		}
		
		public function set issueCounterURL(value:String):void
		{
			if (value != _issueCounterURL)
			{
                _issueCounterURL = value;
				dispatchEvent(new Event("issueCounterURLChanged"));
			}
		}
		
		private var _githubURL:String = "";
		
		[Bindable("githubURLChanged")]
		public function get githubURL():String
		{
			return _githubURL;
		}
		
        public function set githubURL(value:String):void
        {
            if (value != _githubURL)
            {
                _githubURL = value;
                dispatchEvent(new Event("githubURLChanged"));
            }
        }
		
        private var _productList:Array;
        
        [Bindable("productListChanged")]
        public function get productList():Array
        {
            return _productList;
        }
        
        public function set productList(value:Array):void
        {
            if (value != _productList)
            {
                _productList = value;
                dispatchEvent(new Event("productListChanged"));
                currentProduct = productList[0];
            }
        }
        
        private var _currentProduct:Product;
        
        [Bindable("currentProductChanged")]
        public function get currentProduct():Product
        {
            return _currentProduct;
        }
        
        public function set currentProduct(value:Product):void
        {
            _currentProduct = value;
            
            if (value.releases == null)
                getReleases();
            else 
            {
                releases = value.releases;
                releaseCount = value.releases.length;
            }
            dispatchEvent(new Event("currentProductChanged"));
        }
        
        [Bindable("currentProductChanged")]
        public function get currentDescription():String
        {
            return _currentProduct.description;
        }
        
        private var _reporterURL:String = "";
        
        [Bindable("reporterURLChanged")]
        public function get reporterURL():String
        {
            return _reporterURL;
        }
        
        public function set reporterURL(value:String):void
        {
            if (value != _reporterURL)
            {
                _reporterURL = value;
                dispatchEvent(new Event("reporterURLChanged"));
            }
        }
        
		private var _archiveURL:String;
		
		[Bindable("archiveURLChanged")]
		public function get archiveURL():String
		{
			return _archiveURL;
		}
		
		public function set archiveURL(value:String):void
		{
			if (value != _archiveURL)
			{
                _archiveURL = value;
				dispatchEvent(new Event("archiveURLChanged"));
			}
		}
        
        private var _numOpenIssues:int;
        
        [Bindable("numOpenIssuesChanged")]
        public function get numOpenIssues():int
        {
            return _numOpenIssues;
        }
        
        public function set numOpenIssues(value:int):void
        {
            if (value != _numOpenIssues)
            {
                _numOpenIssues = value;
                dispatchEvent(new Event("numOpenIssuesChanged"));
            }
        }
        
        private var _numForks:int;
        
        [Bindable("numForksChanged")]
        public function get numForks():int
        {
            return _numForks;
        }
        
        public function set numForks(value:int):void
        {
            if (value != _numForks)
            {
                _numForks = value;
                dispatchEvent(new Event("numForksChanged"));
            }
        }
        
        private var configData:Object;
        
        private function completeHandler(event:Event):void
        {
            var svc:HTTPService = HTTPService(event.target);
            var data:Object = svc.json;
            configData = data;
            archiveURL = data['archiveURL'];
            reporterURL = data['reporterURL'];
            githubURL = data['githubURL'];
            issueCounterURL = data['issueCounterURL'];
            projectName = data['projectName'];
            projectTitle = data['projectTitle'];
            projectIcon = data['projectIcon'];
            reporterKey = data['reporterKey'];
            productList = createProducts(data['products']);
            dispatchEvent(new Event("configChanged"));            
        }

        private var reporterKey:String;
        
        private var report:Object;
        
        private function reporterCompleteHandler(event:Event):void
        {
            var svc:HTTPService = HTTPService(event.target);
            var headers:Array = svc.responseHeaders;
            trace(headers);
            report = svc.json;
            dispatchEvent(new Event("reportChanged"));            
        }
        
        private var _numPMC:int = -1;
        
        [Bindable("reportChanged")]
        public function get numPMC():int
        {
            if (_numPMC < 0)
            {
                _numPMC = report["count"][reporterKey][0];
            }
            return _numPMC;
        }

        private var _numCommitters:int = -1;
        
        [Bindable("reportChanged")]
        public function get numCommitters():int
        {
            if (_numCommitters < 0)
            {
                _numCommitters = report["count"][reporterKey][1];
            }
            return _numCommitters;
        }
        
        private var _numDevSubscribers:int = -1;
        
        [Bindable("reportChanged")]
        public function get numDevSubscribers():int
        {
            if (_numDevSubscribers < 0)
            {
                _numDevSubscribers = countSubscribers(report["mail"][reporterKey][reporterKey + ".apache.org-dev"]);
            }
            return _numDevSubscribers;
        }

        private var _numUsersSubscribers:int = -1;
        
        [Bindable("reportChanged")]
        public function get numUsersSubscribers():int
        {
            if (_numUsersSubscribers < 0)
            {
                _numUsersSubscribers = countSubscribers(report["mail"][reporterKey][reporterKey + ".apache.org-users"]);
            }
            return _numUsersSubscribers;
        }
        
        [Bindable("configChanged")]
        public function get devListName():String
        {
            return configData["devListName"];
        }
        
        [Bindable("configChanged")]
        public function get devListSubscribeURL():String
        {
            return configData["devListSubscribeURL"];
        }
        
        [Bindable("configChanged")]
        public function get devListUnsubscribeURL():String
        {
            return configData["devListUnsubscribeURL"];
        }
        
        [Bindable("configChanged")]
        public function get devListURL():String
        {
            return configData["devListURL"];
        }
        
        [Bindable("configChanged")]
        public function get devListArchiveURL():String
        {
            return configData["devListArchiveURL"];
        }
        
        [Bindable("configChanged")]
        public function get usersListName():String
        {
            return configData["usersListName"];
        }
        
        [Bindable("configChanged")]
        public function get usersListURL():String
        {
            return configData["usersListURL"];
        }
        
        [Bindable("configChanged")]
        public function get usersListSubscribeURL():String
        {
            return configData["usersListSubscribeURL"];
        }
        
        [Bindable("configChanged")]
        public function get usersListUnsubscribeURL():String
        {
            return configData["usersListUnsubscribeURL"];
        }
        
        [Bindable("configChanged")]
        public function get usersListArchiveURL():String
        {
            return configData["usersListArchiveURL"];
        }
        
        [Bindable("configChanged")]
        public function get issuesMainURL():String
        {
            return configData["issuesMainURL"];
        }
        
        [Bindable("configChanged")]
        public function get issuesCreateURL():String
        {
            return configData["issuesCreateURL"];
        }
        
        [Bindable]
        public var releases;
        
        [Bindable]
        public var releaseCount;
        
        private function countSubscribers(data:Object):int
        {
            var total:int = 0;
            for (var p:String in data)
            {
                var delta:int = data[p];
                total += delta;
            }
            return total;
        }
        
        private var archiveList:Array;
        private var releaseList:Array;
        
        private function archiveCompleteHandler(event:Event):void
        {
            var p:Product = currentProduct;
            archiveList = findLinks(releaseService.data, p.excludes);
            if (p.releaseURL.indexOf("http") == -1)
                releaseService.url = p.releaseURL + "index.html";
            else
                releaseService.url = p.releaseURL;
            releaseService.removeEventListener("complete", archiveCompleteHandler);
            releaseService.addEventListener("complete", releaseCompleteHandler);
            releaseService.send();
        }
        
        private function releaseCompleteHandler(event:Event):void
        {
            releaseService.removeEventListener("complete", releaseCompleteHandler);
            var p:Product = currentProduct;
            releaseList = findLinks(releaseService.data, p.excludes);
            p.releases = mergeLists();
            releases = p.releases;
            releaseCount = p.releases.length;
        }
        
        private function createProducts(data:Array):Array
        {
            var n:int = data.length;
            for (var i:int = 0; i < n; i++)
            {
                var obj:Object = data[i];
                var p:Product = new Product(obj);
                data[i] = p;
            }
            return data;
        }
        
        private function findLinks(s:String, excludes:Array):Array
        {
            var arr:Array = [];
            var c:int = s.indexOf("href=");
            while (c != -1)
            {
                var c2:int = s.indexOf('"', c + 7);
                var name:String = s.substring(c + 6, c2);
                if (excludes.indexOf(name) == -1)
                {
                    if (name.charAt(name.length - 1) == "/")
                        name = name.substr(0, name.length - 1);
                    arr.push(name);
                }
                c = s.indexOf("href", c2);
            }
            return arr;
        }
        
        private function mergeLists():Array
        {
            sortList(releaseList);
            sortList(archiveList);
            var n:int = archiveList.length;
            for (var i:int = 0; i < n; i++)
            {
                var r:String = archiveList[i];
                if (releaseList.indexOf(r) == -1)
                {
                    releaseList.push(r + ARCHIVED);
                }
            }
            return releaseList;
        }
        
        private function sortList(arr:Array):Array
        {
            return arr.sort(versionCompareFunction);
        }
        
        private function versionCompareFunction(a:String, b:String):int
        {
            var aparts:Array = a.split(".");
            var bparts:Array = b.split(".");
            var n:int = Math.max(aparts.length, bparts.length);
            for (var i:int = 0; i < n; i++)
            {
                var avalue:int = 0;
                if (i < aparts.length)
                    avalue = parseInt(aparts[i]);
                var bvalue:int = 0;
                if (i < bparts.length)
                    bvalue = parseInt(bparts[i]);
                if (avalue < bvalue)
                    return 1;
                if (avalue > bvalue)
                    return -1;
            }
            return 0;
        }
        
        private function getReleases():void
        {
            var p:Product = currentProduct;
            if (p.archiveURL.indexOf("http") == -1)
                releaseService.url = p.archiveURL + "index.html";
            else           
                releaseService.url = p.archiveURL;
            releaseService.addEventListener("complete", archiveCompleteHandler);
            releaseService.send();
        }

	}
}