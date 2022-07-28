//
//  MetalVC.swift
//  AVFoundationDemo
//
//  Created by 刘靖煌 on 2022/7/27.
//

import UIKit
import MetalKit
import AVFoundation
import MetalPerformanceShaders

class MetalVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, MTKViewDelegate {
    
    // Metal渲染相关
    var mtkView:MTKView = MTKView()
    var commandQueue:MTLCommandQueue!
    var texture:MTLTexture!
    var textureCache:CVMetalTextureCache!
    
    // 负责输入和输出设备之间数据传递的会话
    var captureSession:AVCaptureSession = AVCaptureSession()
    
    // 负责从AVCaptureDevice获得输入数据
    var captureDeviceInput:AVCaptureDeviceInput!
    
    // 摄像捕获输出
    var captureVideoDataOutput:AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    
    let processQueue = DispatchQueue.init(label: "mProcessQueue")
     
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置Metal相关
        setupMetal()
        
        // 设置采集相关
        setupCaptureSession()
    }
    
    func setupMetal() {
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        mtkView.frame = CGRect(x: 0, y: (height - width*16/9)/2 + 20, width: width, height: width*16/9)
        mtkView.device = MTLCreateSystemDefaultDevice()
        view.insertSubview(mtkView, at: 0)
        
        mtkView.delegate = self
        mtkView.framebufferOnly = false // 允许读写操作
//        mtkView.transform = CGAffineTransform(rotationAngle: Double.pi / 2)
        commandQueue = mtkView.device!.makeCommandQueue()
        CVMetalTextureCacheCreate(nil, nil, mtkView.device!, nil, &textureCache)
        
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = .hd1280x720
        
        // 选择摄像头
        var inputCamera:AVCaptureDevice? = nil
        let devices = AVCaptureDevice.devices(for: .video)
        for device in devices {
            if device.position == .front {
                inputCamera = device
            }
        }
        
        // 设置输入设备，加到回话
        captureDeviceInput = try? AVCaptureDeviceInput(device: inputCamera!)
        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
        }
        
        // 设置输出
        captureVideoDataOutput.alwaysDiscardsLateVideoFrames = false
        captureVideoDataOutput.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey):(kCVPixelFormatType_32BGRA)]
        captureVideoDataOutput.setSampleBufferDelegate(self, queue: self.processQueue)
        if captureSession.canAddOutput(captureVideoDataOutput) {
            captureSession.addOutput(captureVideoDataOutput)
        }
        
        // 
        let connection:AVCaptureConnection = captureVideoDataOutput.connection(with: .video)!
        connection.videoOrientation = .portrait
        if connection.isVideoMirroringSupported {
            connection.isVideoMirrored = true
        }
        
        captureSession.startRunning()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        if (texture != nil) {
            // 创建指令缓冲
            let commandBuffer:MTLCommandBuffer = commandQueue.makeCommandBuffer()!
            
            // 把MKTView作为目标纹理
            let drawingTexture:MTLTexture = view.currentDrawable!.texture
            
            // 这里的sigma值可以修改，sigma值越高图像越模糊
            let filter:MPSImageGaussianBlur = MPSImageGaussianBlur(device: mtkView.device!, sigma: 1)
            // 把摄像头返回图像数据的原始数据
            filter.encode(commandBuffer: commandBuffer, sourceTexture: texture, destinationTexture: drawingTexture)
            // 展示数据
            commandBuffer.present(view.currentDrawable!)
            commandBuffer.commit()
            
            texture = nil
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        let width:Int = CVPixelBufferGetWidth(pixelBuffer)
        let height:Int = CVPixelBufferGetHeight(pixelBuffer)
        
        var tmpTexture:CVMetalTexture? = nil
        
        //如果MTLPixelFormatBGRA8Unorm和摄像头采集时设置的颜色格式不一致，则会出现图像异常的情况；
        var status:CVReturn = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, self.textureCache, pixelBuffer, nil, .bgra8Unorm, width, height, 0, &tmpTexture)
        if(status == kCVReturnSuccess)
        {
            self.mtkView.drawableSize = CGSize(width: width, height: height);
            self.texture = CVMetalTextureGetTexture(tmpTexture!);
        }
        
        
        
    }
}
