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
package utils {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import spark.components.Label;

/**
 *    UI class that shows FPS or RPS current value.
 *
 */
public class FPSDisplay extends Label {
    /**
     * Means that fps should be measured by enterFrame events.
     * @private
     */
    public static const FPS:String = "fps";

    /**
     * Means that fps should be measured by render events.
     * @private
     */
    public static const RPS:String = "rps";

    /**
     * Constructor.
     */
    public function FPSDisplay() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler)
    }

    /**
     * Timer with 1 sec daley.
     */
    private var timer:Timer;

    [Bindable]
    /**
     * FPS value.
     */ public var fps:uint = 0;

    /**
     * Storage for active.
     */
    private var _active:Boolean = true;

    [Bindable("activeChanged")]
    [Inspectable(category="General", defaultValue=true)]
    /**
     * Flag that used to run or stop measurement.
     */ public function get active():Boolean {
        return _active;
    }

    /**
     *    @private
     */
    public function set active(value:Boolean):void {
        if (_active != value) {
            _active = value;
            activeChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("activeChanged"));
        }
    }

    /**
     * Storage for mode.
     * @private
     */
    private var _mode:String = FPSDisplay.FPS;

    [Bindable("modeChanged")]
    [Inspectable(category="General", defaultValue="fps", enumeration="fps,rps")]
    /**
     * Type of rate (actual or render).
     * @default actualRate
     */ public function get mode():String {
        return _mode;
    }

    /**
     *    @private
     */
    public function set mode(value:String):void {
        if (_mode != value) {
            _mode = value;
            frameCount = 0;
            invalidateProperties();
            dispatchEvent(new Event("modeChanged"));
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Life cycle
    //
    //--------------------------------------------------------------------------
    /**
     * Inner flag that indicates whether component is on stage.
     * @private
     */
    private var _staged:Boolean;

    /**
     * @inheritDoc
     */
    override protected function createChildren():void {
        super.createChildren()

        if (!timer) {
            timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER, timerHandler);
        }
    }

    /**
     * Dirty flag that indicates whether active or staged properties were changed.
     * @private
     */
    private var activeChanged:Boolean = false;

    /**
     * @inheritDoc
     */
    override protected function commitProperties():void {
        super.commitProperties();

        if (activeChanged) {
            if (_active && _staged) {
                addEventListener(Event.ENTER_FRAME, frameHandler);
                addEventListener(Event.RENDER, frameHandler);

                frameCount = 0;
                timer.start();
            } else {
                removeEventListener(Event.ENTER_FRAME, frameHandler);
                removeEventListener(Event.RENDER, frameHandler);
            }

            activeChanged = false;
        }

    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    /**
     * Frame count per second.
     * @prevate
     */
    private var frameCount:int = 0;

    /**
     * Handler for enterFrame event.
     * @private
     */
    private function frameHandler(event:Event):void {
        if ((mode == FPSDisplay.FPS && event.type == Event.ENTER_FRAME) || (mode == FPSDisplay.RPS && event.type == Event.RENDER)) {
            frameCount ++;
        }
    }

    /**
     * Handler for timer event.
     * @private
     */
    private function timerHandler(event:TimerEvent):void {
        fps = frameCount;
        text = mode + "=" + fps.toString();
        frameCount = 0;
    }

    /**
     * Handler for addedToStag event.
     * @private
     */
    private function addedToStageHandler(event:Event):void {
        _staged = true;
        activeChanged = true;
        invalidateProperties();
    }

    /**
     * Handler for removedFromStage event.
     * @private
     */
    private function removedFromStageHandler(event:Event):void {
        _staged = false;
        activeChanged = true;
        invalidateProperties();
    }
}
}
