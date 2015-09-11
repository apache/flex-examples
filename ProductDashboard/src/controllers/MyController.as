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
package controllers
{
	import models.MyModel;
	
	import org.apache.flex.core.Application;
	import org.apache.flex.core.BrowserWindow;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.events.Event;
    	
	public class MyController implements IDocument
	{
		public function MyController(app:Application = null)
		{
			if (app)
			{
				this.app = app as ProjectDashboard;
				app.addEventListener("viewChanged", viewChangeHandler);
			}
		}
		
		private var app:ProjectDashboard;
		
		private function viewChangeHandler(event:Event):void
		{
			app.initialView.addEventListener(MyInitialView.EVENT_PRODUCT_CHANGED, productChangedHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_DOWNLOAD_PRODUCT, downloadProductHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_DEV_SUBSCRIBE, devSubscribeHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_DEV_UNSUBSCRIBE, devUnsubscribeHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_DEV_ARCHIVE, devArchiveHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_DEV_MAIL, devMailHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_USERS_SUBSCRIBE, usersSubscribeHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_USERS_UNSUBSCRIBE, usersUnsubscribeHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_USERS_ARCHIVE, usersArchiveHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_USERS_MAIL, usersMailHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_ISSUES_TRACKER, issuesTrackerHandler);
            app.initialView.addEventListener(MyInitialView.EVENT_ISSUES_CREATE, issuesCreateHandler);
		}
		
        private function downloadProductHandler(event:Event):void
        {
            var finalURL:String;
            
            var p:Product = MyModel(app.model).productList[MyInitialView(app.initialView).productList.selectedIndex];
            var release:String = p.releases[MyInitialView(app.initialView).releaseList.selectedIndex];
            var c:int = release.indexOf(MyModel.ARCHIVED);
            if (c != -1)
            {
                release = release.substring(0, c);
                finalURL = p.archivePattern;
                finalURL = finalURL.replace(new RegExp("__version__", "g"), release);
            }
            else
            {
                finalURL = p.releasePattern;
                finalURL = finalURL.replace(new RegExp("__version__", "g"), release);                    
            }
            BrowserWindow.open(finalURL, null)                
        }
        
        private function openBrowserWindow(url:String):void
        {
            BrowserWindow.open(url, null);
        }
        
		private function devSubscribeHandler(event:Event):void
		{
			openBrowserWindow(MyModel(app.model).devListSubscribeURL);
		}
		
        private function devUnsubscribeHandler(event:Event):void
        {
            openBrowserWindow(MyModel(app.model).devListUnsubscribeURL);
        }
        
        private function devArchiveHandler(event:Event):void
        {
            openBrowserWindow(MyModel(app.model).devListArchiveURL);
        }
        
        private function devMailHandler(event:Event):void
        {
            openBrowserWindow(MyModel(app.model).devListURL);
        }
        
        private function usersSubscribeHandler(event:Event):void
        {
            openBrowserWindow(MyModel(app.model).usersListSubscribeURL);
        }
        
        private function usersUnsubscribeHandler(event:Event):void
        {
            openBrowserWindow(MyModel(app.model).usersListUnsubscribeURL);
        }
        
        private function usersArchiveHandler(event:Event):void
        {
            openBrowserWindow(MyModel(app.model).usersListArchiveURL);
        }
        
        private function usersMailHandler(event:Event):void
        {
            openBrowserWindow(MyModel(app.model).usersListURL);
        }
        
        private function issuesTrackerHandler(event:Event):void
        {
            openBrowserWindow(MyModel(app.model).issuesMainURL);
        }
        
        private function issuesCreateHandler(event:Event):void
        {
            openBrowserWindow(MyModel(app.model).issuesCreateURL);
        }
        
		public function setDocument(document:Object, id:String = null):void
		{
			this.app = document as ProjectDashboard;
			app.addEventListener("viewChanged", viewChangeHandler);
		}
        
        
        private function productChangedHandler(event:Event):void
        {
            var p:Product = MyModel(app.model).productList[MyInitialView(app.initialView).productList.selectedIndex];
            MyModel(app.model).currentProduct = p;
        }            

	}
}