//
//  AlunoDAO.swift
//  Agenda
//
//  Created by Thiago Gasbarro Jesus on 23/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import CoreData

class AlunoDAO: NSObject {
    
    var gerenciadorDeResultados:NSFetchedResultsController<Aluno>?
    var contexto:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func recuperaAluno() -> Array<Aluno> {
        let pesquisaAluno:NSFetchRequest<Aluno> = Aluno.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let listaDeAlunos = gerenciadorDeResultados?.fetchedObjects else { return [] }
        
            return listaDeAlunos
    }
    
    func salvaAluno(dicionarioDeAluno:Dictionary<String, Any>) {
        
        var aluno:NSManagedObject?
        guard let id = UUID(uuidString: dicionarioDeAluno["id"] as! String) else { return }
        
        let alunos = recuperaAluno().filter() { $0.id == id }
        
        if alunos.count > 0 {
            guard let alunoEncontrado = alunos.first else { return }
            aluno = alunoEncontrado
        } else {
            let entidade = NSEntityDescription.entity(forEntityName: "Aluno", in: contexto)
            aluno = NSManagedObject(entity: entidade!, insertInto: contexto)
        }
        
        aluno?.setValue(id, forKey: "id")
        aluno?.setValue(dicionarioDeAluno["nome"], forKey: "nome")
        aluno?.setValue(dicionarioDeAluno["endereco"], forKey: "endereco")
        aluno?.setValue(dicionarioDeAluno["telefone"], forKey: "telefone")
        aluno?.setValue(dicionarioDeAluno["site"], forKey: "site")
        
        guard let nota = dicionarioDeAluno["nota"] else { return }
        
        if (nota is String) {
            aluno?.setValue((dicionarioDeAluno["nota"] as! NSString).doubleValue, forKey: "nota")
        }
        else {
            let conversaoDeNota = String(describing: nota)
            aluno?.setValue((conversaoDeNota as NSString).doubleValue, forKey: "nota")
        }
        
        atualizaContexto()

    }
    
    func deletaAluno(aluno:Aluno){
        contexto.delete(aluno)
        atualizaContexto()
    }
    
    
    func atualizaContexto() {
        
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }

}
