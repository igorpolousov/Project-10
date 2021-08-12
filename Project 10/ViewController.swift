//
//  ViewController.swift
//  Project 10
//  Day 43
//  Created by Igor Polousov on 10.08.2021.
//

import UIKit

class ViewController: UICollectionViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Массив с объектами класса Person
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Добавили кнопку в navigation controller
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
    }
    
    // Указали сколько будет ячеек в коллекции
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    // Метод для создания ячейки в коллекции
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Нужно использовать type casting чтобы ViewController использовал не стандартную ячейку, а ячейку с классом PersonCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            
            // Если ячейка не будет найдена покажет сообщение об ошибке
            fatalError("Unable to dequeue Personcell ")
        }
        // Создали константу чтобы получить доступ к элементу массива people
       let person = people[indexPath.item]
        
        // Создали константу в которой указан путь к названию картинки
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        
        // Свойству картинки присвоено свойство UIImage с указнием пути к файлу в виде string(второе слово path после path)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        // Свойству name присвоено значение из массива
        cell.name.text = person.name
        // Рамка для картинки серого цвета
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.4).cgColor
        // Толщина картинки
        cell.imageView.layer.borderWidth = 2
        // Закругление краев картинки
        cell.imageView.layer.cornerRadius = 4
        // Закругление краёв ячейки
        cell.layer.cornerRadius = 8
        return cell
    }
    
    
    // Метод с помощью которого вызывается AlertController при нажатии на картинку
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Получаем значения экземпляра из people для нажатой ячейки
        let person = people[indexPath.item]
        // Создаём alert controller
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        // Добавляем текстовое поле
        ac.addTextField()
        // Добавляем действие к alert controller с назанием Ок.
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] action in
            // Принимает значение из текстового поля
            guard let newName = ac?.textFields?[0].text else { return }
            // Присваевает значение элементу из массива
            person.name = newName
            // Перезагрузили таблицу
            self?.collectionView.reloadData()
        })
        
        // Добавили действие удаления
        ac.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] action in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        })
        
        // Добавили кнопку cancel
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // Показали контроллер
        present(ac, animated: true)
        
    }
   
    
    @objc func addNewPerson() {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
        
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
    
}

