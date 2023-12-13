import cv2 as cv


def convert_frame(frame):
	"""
    Convert 256 bit rgb to 8 bit
	frame: opencv image
	"""
	bytes_int = []
	rows,cols,_ = frame.shape

	for i in range(rows):
		for j in range(cols):

			pixel = frame[i,j]
			# breakpoint()
			# eight_bit_pixel = (round(pixel[0]*7/255) << 5) \
			# 				+ (round(pixel[1]*7/255) << 2) \
			# 				+ (round(pixel[2]*3/255))

            # [B, B, G, G, G, R, R, R]

			eight_bit_pixel = (round(pixel[2]*3/255) << 6) \
							+ (round(pixel[1]*7/255) << 3) \
							+ (round(pixel[0]*7/255))
       
			bytes_int.append(eight_bit_pixel)

	return bytes_int


def get_img_list(img_path):

	img = cv.imread(img_path)

	print(img.shape)

	img_test1 = cv.resize(img, (800, 600))

	return convert_frame(img_test1)


def video():
    name = "daliwang.flv"
    print(name)

    reg8 = []

    video = cv.VideoCapture(name)
    video.set(cv.CAP_PROP_FPS, 10) # 10 frames every second
 
    # with Bar('video...') as bar:
    i = 0
    counter = 0
    while True:
        ret, frame = video.read()
        # breakpoint()
        if not ret:
            break

        if counter == 0:
            counter += 1
        else:
            counter += 1
            counter = counter % 3
            continue
        b = cv.resize(frame, (200, 150), 
            fx=0, fy=0, interpolation=cv.INTER_CUBIC)
        # might as well delete this line
        b = cv.cvtColor(b, cv.COLOR_RGB2BGR)
        

        reg8 += convert_frame(b)
        i += 1
        counter += 1

        if i == 120:
            break
        elif i % 30 == 0:
            print(f'done converting frame {i}')
    video.release()
    with open(f"{name.rstrip('.flv')}.bin", "wb") as fw:
        fw.write(bytes(reg8))
    print(f'size: {len(reg8)}Bytes')


if __name__ == '__main__':
    video()
