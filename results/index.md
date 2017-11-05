# 蔡介豪 <span style="color:red">(103061101)</span>

# DSP Lab HW 2 / Harris Corner Detector

## Overview
The project is related to Harris corner detector.



## Implementation
#<img src="../1.PNG" width="50%"/>

1. Grey scale
	<pre><code>I_grey = double(rgb2gray(frame))/255;</code></pre>

2. Gradient filter & Gaussian smootherd
	<pre><code>Ix = imfilter(I_grey, dx);
	Iy = imfilter(I_grey, dy);Ix2 = Ix.*Ix;
	Ix2_smoothed = imfilter(Ix2, g);
	Iy2 = Iy.*Iy;
	Iy2_smoothed = imfilter(Iy2, g);
	IxIy = Ix.*Iy;
	IxIy_smoothed = imfilter(IxIy, g);</code></pre>

3. Make max R value to be 1000
	<pre><code>R = (1000/max(max(R)))*R;</code></pre>

4. Using B = ordfilt2(A,order,domain) to complment a maxfilter
	<pre><code>sze = 2*r+1;
	MX = ordfilt2(R, sze^2, ones(sze, sze));
	RBinary = (R == MX) & (MX > Threshold);</code></pre>

5. Get location of corner points not along image's edges
	<pre><code>offe = r-1;
	count=sum(sum(RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe))); 	
	R=R*0;
	R(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe)=RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe);
	[r1,c1] = find(R);</code></pre>
	
### Results
IxIy_smoothed:
<img src="../2.jpg" width="50%"/>

Final results:
<img src="../3.jpg" width="50%"/>