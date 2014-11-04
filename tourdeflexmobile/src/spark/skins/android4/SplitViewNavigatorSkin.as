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

package spark.skins.android4
{
	import mx.core.mx_internal;
	
	import spark.components.Callout;
	import spark.components.Group;
	import spark.components.SkinnablePopUpContainer;
	import spark.components.SplitViewNavigator;
	import spark.layouts.HorizontalLayout;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	use namespace mx_internal;
	
	/**
	 *  The default skin for the SplitViewNavigator component.  This skin is
	 *  chromeless and doesn't draw a background, border or separator.  
	 *  It only contains a single content group with a horizontal layout to hold 
	 *  the navigators, and a Callout component.  
	 *  The Callout component uses the default values for its layout properties.
	 * 
	 *  @see spark.components.Callout
	 *  @see spark.components.SplitViewNavigator
	 * 
	 *  @langversion 3.0
	 *  @playerversion AIR 3
	 *  @productversion Flex 4.6
	 */
	public class SplitViewNavigatorSkin extends MobileSkin
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 3
		 *  @productversion Flex 4.6
		 */
		public function SplitViewNavigatorSkin()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @copy spark.components.SkinnableContainer#contentGroup
		 */
		public var contentGroup:Group;
		
		/**
		 *  @copy spark.components.SplitViewNavigator#viewNavigatorPopUp
		 */ 
		public var viewNavigatorPopUp:SkinnablePopUpContainer;
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @copy spark.skins.spark.ApplicationSkin#hostComponent
		 */
		public var hostComponent:SplitViewNavigator;
		
		//--------------------------------------------------------------------------
		//
		// Overridden Methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 */
		override protected function createChildren():void
		{
			// Create the layout for the content group
			var hLayout:HorizontalLayout = new HorizontalLayout();
			
			// A gap of 1 is used to reveal a thin line of the background between
			// each child navigator.  This serves as a divider.  To change the look
			// of the divider, change the backgroundColor style.
			hLayout.gap = 1;
			
			// Create the contentGroup
			contentGroup = new Group();
			contentGroup.id = "contentGroup";
			contentGroup.layout = hLayout;
			addChild(contentGroup);
			
			// Create the callout but don't add it to display list
			viewNavigatorPopUp = new Callout();
			viewNavigatorPopUp.id = "viewNavigatorPopUp";
		}
		
		/**
		 *  @private
		 */
		override protected function measure():void
		{
			super.measure();
			
			measuredWidth = contentGroup.getPreferredBoundsWidth();
			measuredHeight = contentGroup.getPreferredBoundsHeight();
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			contentGroup.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
			contentGroup.setLayoutBoundsPosition(0, 0);
		}
		
		/**
		 *  @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// Background is used to draw the divider between each navigator
			var color:uint = getStyle("backgroundColor");
			graphics.beginFill(color);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
		}
	}
}