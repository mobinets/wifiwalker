# WifiWalker
This project devises a novel scheme for human-identification scheme with walking using [CSI](https://en.wikipedia.org/wiki/Channel_state_information) (short for channel state information).
## Preparation
### The hardware
1. _PC with Ubuntu 14.04_
2. _Intel 5300 wireless card_

***Notes:***
* 64-bit Ubuntu 14.04 is recommended because a better tool support (although 12.04 and 32-bit Ubuntu are also compatible).
* We are not sure if other wireless cards could work.
### Installation of Linux csi tool
You could complete the installation according:

**[http://dhalperi.github.io/linux-80211n-csitool/installation.html](http://dhalperi.github.io/linux-80211n-csitool/installation.html)**

### Collect the csi data
CSI data is physical information actually, the linux csi tool obtain it using wireless card while the PC keeps communicating with other devices (a router in our case),
 and transmitted physical csi to application layer which is shown as complex number.

So before collect csi data, you should connect to a router and ping the router. There are some ways to achive this. In our case, **iw** is adopted.
According to [Installation Step](http://dhalperi.github.io/linux-80211n-csitool/installation.html), we **enable the modified driver** by inputing command:
```bash
sudo modprobe -r iwlwifi mac80211
sudo modprobe iwlwifi connector_log=0x1
```
Then we connect our router using **iw**, here are the main iw command we need.
```bash
//scan the wireless devices：
iw dev
//look up a specified wireless network card（assuming it is wlan0）：
iw dev wlan0 link
//enable a specified wireless network card（assuming it is wlan0）：
ip link set wlan0 up
//connect to AP ([essid] is replaced by your AP essid)：
iw wlan0 connect [essid]
//DHCP to get a IP from router
dhclient wlan0
```
Finally we begin logging CSI to a file (.dat)
```bash
sudo linux-80211n-csitool-supplementary/netlink/log_to_file csi.dat
```
***Notes:***
* All the command we input is executed by sudo mode.
* You had better execute the two command for **enable the modified driver** after reboot your PC.
* In our case, the router does not need password to connect it.

## Framework of wifiwalker
Gaits are a distinctive feature for individuals. Several recent works have been done to exploit CSI to achieve the gaits identification. The basic idea is to extract the unique influences on the CSIs by the gaits from different people.
After preparation, we get the data file (.dat). According to [How do I process CSI with MATLAB or Octave?](http://dhalperi.github.io/linux-80211n-csitool/faq.html), we use matlab to proccess these data.  Here are the main procedures:

### Filter the noise
There are some ambient noise which falls in high frequency band, We apply Butterworth low-pass filter to all CSI series of all subcarriers for all antenna pairs. We use the toolbox in matlab to build the filter. The waves of before and after filter is like this:

![Before Filter](/img/beforefilter.png) ![After Filter](/img/afterfilter.png)

### Extract the main components by PCA
With *Ntx* transmitter antennas, *Nrx* receiver antennas and *Ns* OFDM subcarriers, there will be *Ntx* ×*Nrx* ×*Ns* subcarriers for the signal transmission at the same time. While it has been observed by several works that the changes by human activity on different subcarriers are correlated. To reduce computation complexity, we adopt PCA to extract the main components which reflect the gaits of humans.

### Cut out effective section
The common way is **slide window**, during which we need to judge if the metric (like *mean value*) is above the threshold or not. If yes, we could get the *start point*. So it is with *end point*.  Data during *start point* and *end point* is the effective section we need. But this is a challenging job because the experiment setup could not be fixed. We have not solve this problem very well, so we set a fixed-length data to avoid this procedure. But you could refer to our codes in ***csionline.m***, which is our exploration.

### Feature extraction
To recognize different persons, we should extract some features that could characterize different gaits in our experiment. Here we adopt two methods to achieve this.
* **Artificial selection** We select several popular features including median amplitude, standard deviation, max amplitude, max amplitude and etc, which has been observed that the *Correct Identification* is OK but not so good.
* **Discrete wavelet transform** Discrete wavelet transform (DWT) is a excellent method to compress data meanwhile captures both frequency and location information. In another way, DWT could roughly reserve the shape of a wave while reduce its dimension. If the compression is enough, a list of points in the wave could be regarded as the features. So we recommend this method because the result is better and avoid human's subjective factors.

### Training and classification
There are many methods for classification. We adopted *kNN* and *Decision-Tree* because they are uncomplicated and effective respectively. The input of classifier is the features extracted above and the ouput is the classification result.

## ***Notes:***
* The code in ***offlinetotaltrain.m*** gives the whole procedures above.
* Our experiment setup for classification is offline, we have also tried the experiment in an online way but the result is not satisfactory. The idea of our trys for online way is pipe in Unix, but it get stuck because the speed of stream writing is so fast. If you have any way to solve this, welcome to contact us.
