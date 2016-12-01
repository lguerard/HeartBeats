//clear all;

selectWindow("052912 RCM-0004_t01.avi.tif");
nbrSlices = nSlices;
areaResult = newArray(nSlices);
run("Properties...", "channels=1 slices=22 frames=1 unit=px pixel_width=1 pixel_height=1 voxel_depth=1");
setBatchMode(true);

for(i=1;i<=nbrSlices;i++)
{
	measure = 0;
	selectWindow("052912 RCM-0004_t01.avi.tif");
	setSlice(i);
	run("Duplicate...", "title=Mask");
	run("Subtract Background...", "rolling=85 light");
	run("8-bit");
	run("Invert");
	run("Gaussian Blur...", "sigma=5");
	//setAutoThreshold("Mean dark");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Analyze Particles...", "size=50-Infinity pixel clear add");
	//run("Set Measurements...", "area redirect=None decimal=4");
	//run("Measure");
	roiManager("Measure");
	for(j=0;j<nResults;j++)
	{
		measure = measure+getResult("Area",j);
	}
	areaResult[i-1]=measure;
	print(measure);
	selectWindow("052912 RCM-0004_t01.avi.tif");
	setSlice(i);
	if(i==1)
	{
		run("Duplicate...", "title=slice");
		roiManager("Show All without labels");
		run("Flatten");
		selectWindow("slice");
		close();
		
	}
	else
	{
		run("Duplicate...", "title=slice2");
		roiManager("Show All without labels");
		run("Flatten");
		selectWindow("slice2");
		close();
		//run("Set Measurements...", "area redirect=None decimal=4");
		//run("Measure");
		//areaResult[i]=getResult("Area", 0);
		run("Concatenate...", "  title=slice-1 image1=slice-1 image2=slice2-1 image3=[-- None --]");
	}	 
	selectWindow("Mask");
	close();
	selectWindow("Results");
	run("Close");
}

setBatchMode("exit and display");

Array.print(areaResult);
