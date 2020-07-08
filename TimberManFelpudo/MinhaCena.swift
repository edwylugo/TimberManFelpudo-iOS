//
//  MinhaCena.swift
//  TimberManFelpudo
//
//  Created by Edwy Lugo on 25/02/20.
//  Copyright © 2020 Edwy Lugo. All rights reserved.
//
import SpriteKit

class MinhaCena: SKScene {

    var podeJogar = true
    var podeReiniciar = false
    var pontos = 0
    var lado:Bool = false
    var comecou = false
    var escalaBarra:CGFloat = 1.0
    
    let somBate:SKAction = SKAction.playSoundFileNamed("somBolhaPop.wav", waitForCompletion: false)
    let somPancada:SKAction = SKAction.playSoundFileNamed("pancada.wav", waitForCompletion: false)
 
    let textoPontos = SKLabelNode(fontNamed: "True Crimes")
    let textoFimDeJogo = SKLabelNode(fontNamed: "True Crimes")
    
    let barraContorno = SKSpriteNode(imageNamed: "barraOutline")
    var barra:SKShapeNode = SKShapeNode()
    
    var meuBg = SKSpriteNode(imageNamed: "imagemFundo")
    var felpudo = SKSpriteNode(imageNamed: "playerIdle")
    
    var listaBarris:[SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .black
        
        meuBg.size.width = self.size.width
        meuBg.size.height = self.size.height
        meuBg.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        meuBg.zPosition = -1
        
        felpudo.position = CGPoint(x: self.frame.midX-90, y: 110)
        
        self.addChild(meuBg)
        self.addChild(felpudo)
        
        self.iniciaCena()
        
        textoPontos.text = "\(pontos)"
        textoPontos.fontSize = 72
        textoPontos.fontColor = .white
        textoPontos.horizontalAlignmentMode = .center
        textoPontos.verticalAlignmentMode = .top
        textoPontos.position = CGPoint(x:frame.midX ,y:frame.maxY-150)
        textoPontos.zPosition = 100
        
        
        textoFimDeJogo.horizontalAlignmentMode = .center
        textoFimDeJogo.verticalAlignmentMode = .top
        textoFimDeJogo.position = CGPoint(x:frame.midX ,y:frame.midY)
        textoFimDeJogo.zPosition = 100
        textoFimDeJogo.isHidden = true
        
        self.addChild(textoPontos)
        self.addChild(textoFimDeJogo)
        
        
        
        barraContorno.position = CGPoint(x:frame.midX ,y:frame.maxY-100)
        barraContorno.texture?.filteringMode = .nearest
        
        barraContorno.zPosition = 100
        
        barra = SKShapeNode(rect: CGRect(origin: CGPoint(x:0, y:0), size: barraContorno.frame.size))
        barra.fillColor = UIColor.red
        barra.strokeColor = UIColor.clear
        barra.position = CGPoint(x:barraContorno.frame.minX ,y:barraContorno.frame.minY)
        barra.zPosition = 100
        
        barraContorno.setScale(1.15)
        
        self.addChild(barra)
        self.addChild(barraContorno)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(podeReiniciar){
            podeReiniciar = false
            self.zeraCena()
        }else if(podeJogar){
            comecou = true
            for touch in (touches) {
                let location = touch.location(in: self)
                self.run(somBate)
                if(location.x > self.frame.midX){
                    bateDireita()
                }else{
                    bateEsquerda()
                }
            }
        }
    }
    
    func bateEsquerda(){
        lado = false
        felpudo.position = CGPoint(x: self.frame.midX-90, y: 110)
        felpudo.xScale = 1
        felpudo.run(SKAction.setTexture(SKTexture(imageNamed: "playerHit")))
        felpudo.run(SKAction.sequence([SKAction.wait(forDuration: 0.15), SKAction.setTexture(SKTexture(imageNamed: "playerIdle"))]))
        
        if(listaBarris[1].name == "Esq"){
            perdeu()
        }else{
            pontua()
        }
        
        animaBarril(lado)
    }
    func bateDireita(){
        lado = true
        felpudo.position = CGPoint(x: self.frame.midX+90, y: 110)
        felpudo.xScale = -1
        felpudo.run(SKAction.setTexture(SKTexture(imageNamed: "playerHit")))
        felpudo.run(SKAction.sequence([SKAction.wait(forDuration: 0.15), SKAction.setTexture(SKTexture(imageNamed: "playerIdle"))]))
        if(listaBarris[1].name == "Dir"){
            perdeu()
        }else{
            pontua()
        }
        animaBarril(lado)
    }
    
    func animaBarril(_ lado:Bool){
        let dist:CGFloat = lado ? -200 : 200
        listaBarris[0].run(SKAction.sequence([SKAction.moveBy(x: dist, y: 30, duration: 0.25), SKAction.removeFromParent()]))
        listaBarris[0].run(SKAction.rotate(byAngle: dist/10, duration: 0.25))
        listaBarris.remove(at: 0)
        
        empurraBarril()
    }
    
    func empurraBarril(){
        
        for b in listaBarris{
            b.run(SKAction.moveBy(x: 0, y: -b.frame.height, duration: 0.15))
        }
        
        criarBarril(12)
        
    }
    
    func criarBarril(_ i:Int){
        let sorteio = Int.random(in: 0...10)
        var imagemUrl = ""
        var escalaX:CGFloat = 1
        var px:CGFloat = 0
        var nome = ""
        
        if(i > 2){
            if(sorteio < 5){
                imagemUrl = "barril"
                px = self.frame.midX
                nome = "Meio"
            } else if(sorteio < 8){
                imagemUrl = "barrilInimigo"
                px = self.frame.midX+30
                nome = "Dir"
            } else{
                imagemUrl = "barrilInimigo"
                px = self.frame.midX-30
                nome = "Esq"
                escalaX = -1
            }
        } else {
            imagemUrl = "barril"
            px = self.frame.midX
            nome = "Meio"
        }
        
        let barril = SKSpriteNode(imageNamed: imagemUrl)
        barril.position = CGPoint(x: px, y: 110 + CGFloat(i) * barril.size.height)
        barril.xScale = escalaX
        barril.name = nome
        self.addChild(barril)
        listaBarris.append(barril)
    }
    
    func perdeu(){
        self.run(somPancada)
        podeJogar = false
        if(!lado){
            felpudo.run(SKAction.moveBy(x: -300, y: 50, duration: 0.25))
            felpudo.run(SKAction.rotate(byAngle: -30, duration: 0.25))
        }else{
            felpudo.run(SKAction.moveBy(x: 300, y: 50, duration: 0.25))
            felpudo.run(SKAction.rotate(byAngle: 30, duration: 0.25))
        }
        
        textoFimDeJogo.text = "Game Over"
        textoFimDeJogo.fontSize = 72
        textoFimDeJogo.fontColor = .yellow
        textoFimDeJogo.isHidden = false
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.run({
            self.textoFimDeJogo.isHidden = false
            self.textoFimDeJogo.text = "Toque para Reiniciar"
            self.textoFimDeJogo.fontColor = .green
            self.textoFimDeJogo.fontSize = 32
            self.podeReiniciar = true
        })]))
    }
    
    
    func pontua(){
        pontos += 1
        textoPontos.text = "\(pontos)"
        escalaBarra += 0.05
    }
    
    func zeraCena(){
        felpudo.zRotation = 0
        felpudo.position = CGPoint(x: self.frame.midX-90, y: 110)
        pontos = 0
        textoPontos.text = "\(pontos)"
        comecou = false
        escalaBarra = 1
        textoFimDeJogo.isHidden = true
        
        for b in listaBarris {
            b.removeFromParent()
            listaBarris.remove(at: 0)
        }
        listaBarris = []
        iniciaCena()
    }
    
    func iniciaCena(){
        for i in 0..<13{
            criarBarril(i)
        }
        pontos = 0
        podeJogar = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(escalaBarra>1.0){
            escalaBarra = 1.0
        }
        if(podeJogar && comecou){
            escalaBarra -= 0.01
            if(escalaBarra < 0.05){
                perdeu()
            }
        }
        barra.xScale = escalaBarra
    }
}
