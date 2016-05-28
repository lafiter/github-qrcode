package com.fileupload.rest;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.coobird.thumbnailator.Thumbnails;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
public class ClipAvatarCotroller {

	@RequestMapping(value = "/clipUpload")
	public void clipUpload(HttpServletRequest request, HttpServletResponse response) {
		String pathString = request.getRealPath("/");
		MultipartHttpServletRequest mhr = (MultipartHttpServletRequest) request;
		MultipartFile file = mhr.getFile("file");
		try {
			byte[] byt = file.getBytes();
			File f = new File(pathString + File.separator + "upload");
			if (!f.exists())
				f.mkdirs();
			FileOutputStream fis = new FileOutputStream(f.getPath() + File.separator + file.getOriginalFilename());
			fis.write(byt);
			fis.flush();
			fis.close();
			response.getOutputStream().print("/upload/" + file.getOriginalFilename());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	@RequestMapping(value = "/clipUpload")
	public void clipUpload1(HttpServletRequest request, HttpServletResponse response) {
		String pathString = request.getRealPath("/");
		MultipartHttpServletRequest mhr = (MultipartHttpServletRequest) request;
		MultipartFile file = mhr.getFile("file");
		try {
			byte[] byt = file.getBytes();
			File f = new File(pathString + File.separator + "upload");
			if (!f.exists())
				f.mkdirs();
			FileOutputStream fis = new FileOutputStream(f.getPath() + File.separator + file.getOriginalFilename());
			fis.write(byt);
			fis.flush();
			fis.close();
			response.getOutputStream().print("/upload/" + file.getOriginalFilename());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/crop_form")
	public void crop_form(HttpServletRequest request, HttpServletResponse response) {
		int x = Integer.valueOf(request.getParameter("x"));
		int y = Integer.valueOf(request.getParameter("y"));
		int w = Integer.valueOf(request.getParameter("w"));
		int h = Integer.valueOf(request.getParameter("h"));
		String fileName = request.getParameter("fileName");
		String fileString = fileName.substring(fileName.lastIndexOf("\\") + 1);
		String pathString = request.getRealPath("/");
		File f = new File(pathString + File.separator + "clip");
		if (!f.exists())
			f.mkdirs();
		try {
			File f1 = new File(pathString + File.separator + "upload");
			InputStream is = new FileInputStream(f1.getPath() + File.separator + fileString);
			BufferedImage bufferImage = ImageIO.read(is);
			//获取原图的宽和高
			int srcWidth = bufferImage.getWidth();
			int srcHeight = bufferImage.getHeight();
			//X*原图宽/显示需要展示图片框的宽
			//Y*原图高/显示需要展示图片框的高
			//W*原图宽/显示需要展示图片框的宽
			//H*原图高/显示需要展示图片框的高
			int x1 = x * srcWidth / 400;
			int y1 = y * srcHeight / 270;
			int w1 = w * srcWidth / 400;
			int h1 = h * srcHeight / 270;
			Thumbnails.of(bufferImage).sourceRegion(x1, y1, w1, h1).size(w, h).keepAspectRatio(false).toFile(
					f.getPath() + File.separator + UUID.randomUUID().toString().replaceAll("-", "") + ".jpg");
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
}
