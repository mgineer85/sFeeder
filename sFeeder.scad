/*
Author: Michael
20170829
*/

/* [basic parameters] */

//How wide is the tape?
tapeWidth=8; // [8, 12, 16, 24, 36, 48, 72]
//How many feeder to print ganged
numberOfFeeders=2; // [1:1:20]
//Overall length of feeder?
feederLength=180;
//Height of tape's bottom side above bed
tapeLayerHeight=22.8;


/* [advanced] */

//controls the force to keep the tape in place. lower value higher force and though friction
tapeClearance=-0.1;     // [-0.5:0.1:0.5]
bodyHeight=6;
tapeSupportHoleSide=2.8;
tapeSupportNonHoleSide=0.9;


/* [expert] */
//usually don't need to customize the following
tapeHeightClearance=0.6;
//higher values make the arms stronger
additionalWidth=3;
topFinishingLayer=0.3;
tapeGuideUpperOverhang=0.6;
//lower values make the spring smaller thus less force on tape
springWidth=1.2;
springSkew=1.2;
springClearance=0.4;

overallWidth=tapeWidth+additionalWidth;
overallHeight=tapeLayerHeight+tapeHeightClearance+tapeGuideUpperOverhang+topFinishingLayer;
tapeXcenter=(overallWidth/2)+tapeClearance/2;


//make the feeders
gang_feeder();


// customizer specific stuff
// preview[view:north west, tilt:top diagonal]


module gang_feeder() {
    
    difference() {
        union() {
            //cover on left side
            *translate([-2,0,0]) {
                feeder_cover();
            }
                
            //stack up feeders
            for(i=[0:1:numberOfFeeders-1]) {
                translate([i*(tapeWidth+additionalWidth),0,0]) 
                    feeder_body();
            }
            
            //cover on right side
            *translate([(numberOfFeeders)*(tapeWidth+additionalWidth),0,0]) {
                feeder_cover();
            }
        }
    

    }
}

module feeder_cover() {
    cube([2,feederLength,overallHeight]);
}

module feeder_body() {
    translate([0,feederLength,0]) {
        rotate([90,0,0]) {
            difference() {
                
                //main form
                linear_extrude(feederLength) {
                    polygon(points=[
                        //base
                        [0,0],
                        [overallWidth,0],
                    
                        //right arm way up ("spring", outer part)
                        [overallWidth,overallHeight*0.3],
                        [overallWidth-springSkew,tapeLayerHeight-3],
                        [overallWidth-springClearance,tapeLayerHeight],
                    
                        //right arm tape guide
                        [overallWidth-springClearance,overallHeight],
                        [tapeXcenter+tapeWidth/2+tapeClearance-tapeGuideUpperOverhang,overallHeight],
                        [tapeXcenter+tapeWidth/2+tapeClearance-tapeGuideUpperOverhang,tapeLayerHeight+tapeHeightClearance+tapeGuideUpperOverhang],
                        [tapeXcenter+tapeWidth/2+tapeClearance,tapeLayerHeight+tapeHeightClearance],
                        [tapeXcenter+tapeWidth/2+tapeClearance,tapeLayerHeight],
                        [tapeXcenter+tapeWidth/2+tapeClearance-tapeSupportHoleSide,tapeLayerHeight],
                    
                        //right arm way down ("spring", inner part)
                        [overallWidth-springSkew-springWidth,tapeLayerHeight-3],
                        [overallWidth-springWidth,overallHeight*0.3],
                        [tapeXcenter+tapeWidth/2,bodyHeight],
                        
                        //base (inner part)
                        [tapeXcenter-tapeWidth/2+tapeSupportNonHoleSide,bodyHeight],
                        
                        //left arm up (inner part)
                        [tapeXcenter-tapeWidth/2+tapeSupportNonHoleSide,tapeLayerHeight],
                        
                        //left arm tape guide
                        [tapeXcenter-tapeWidth/2,tapeLayerHeight],
                        [tapeXcenter-tapeWidth/2,tapeLayerHeight+tapeHeightClearance],
                        [tapeXcenter-tapeWidth/2+tapeGuideUpperOverhang,tapeLayerHeight+tapeHeightClearance+tapeGuideUpperOverhang],
                        [tapeXcenter-tapeWidth/2+tapeGuideUpperOverhang,overallHeight],
                        
                        //left arm down (outer part)
                        [0,overallHeight],
                        [0,0]

                    ]);
                }
                
                //3 registration points (for magnets, bolts or to screw from top)
                bottom_fixation(feederLength/2);
                bottom_fixation(15);
                bottom_fixation(feederLength-15);
            }
        }
    }
}

module bottom_fixation(pos_y) {
    layerForBridging=0.3;
    cutoutbelow=3.5;
    
    translate([tapeXcenter,cutoutbelow+layerForBridging,pos_y])
            rotate([-90,0,0])
                cylinder(h = bodyHeight+1, r=3.5/2, $fn=20);
    
    translate([tapeXcenter,cutoutbelow,pos_y])
            rotate([90,0,0])
                cylinder(h = 10, r=6.0/2, $fn=20);
    
    translate([tapeXcenter,bodyHeight-1,pos_y])
            rotate([-90,0,0])
                cylinder(h = 2.1, r=6.0/2, $fn=20);
    
}