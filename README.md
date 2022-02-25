<h1 id="title" align="center">Welcome to BloodDonors Frontend 👋</h1>

<h4 align="center">🚧 Blood donors front project in development... 🚧</h4>

> A project to help you connect with blood donors and people who need blood.

### 🔖 Table Of Contents

- 🤔 [How To Run This Project In Your PC](#how-to-run)
- 🚀 [Technologies](#technologies)
- 🌱 [Minimal Requirements](#minimal-requirements)
- 🎊 [Features](#features)
  - 🎇 [Finished](#features-finished)
- 💡 [How To Contribute](#how-to-contribute)
- 🤗 [Authors and Contributors](#contributors)
- 👤 [Supervisor](#supervisor)
- 🔏 [License](#license)

---

<h2 id="how-to-run">🤔 How To Run This Project In Your PC</h2>

### 💻 Step-1: Clone the project in your pc

```sh
git clone https://github.com/AshfaqRahman/BloodDonors-frontend.git
```
or if you use ssh link
```sh
git clone git@github.com:AshfaqRahman/BloodDonors-frontend.git
```

### Step-2: Get the denpendencies

Go to project root and execute the following command in console to get the required dependencies: 
```sh
flutter pub get 
```  

### Step-3: Setting up the enviroment variables
Create create a new file .env in the root directory. And the file should have the followings

```
API_URL=<backend_base_url>/api
SOCKET_URL=<backend_base_url>
```

Example
```
API_URL=http://localhost:3000/api
SOCKET_URL=http://localhost:3000
```

### Step-4: Run the project 

Run in web
```
flutter run -d chrome
```
Run as windows app

```
flutter run -d windows
```

or __If you open your app in vscode or android studio you can run the app using the run button.__ 

### Step-5: Run the backend in your localhost

- [BloodDonors-backend](https://github.com/hmasum52/BloodDonors-backend)

[Back To The Top](#title)

---

<h2 id="technologies">🚀 Technologies</h2>

- Dart
- Flutter
- Websocket

[Back To The Top](#title)

---

<h2 id="minimal-requirements">🌱 Minimal Requirements</h2>

- Dart SDK version: 2.16.0 (stable) + 
- Flutter 2.10.0

[Back To The Top](#title)

---

<h2 id="features">🎊 Features</h2>

<h4 id="features-finished">🎇 Finished</h4>

- [✔️] Authentication: Register and login
- [✔️] BloodPosts Creation
- [✔️] Adding Donation
- [✔️] Direct message
- [✔️] Blood Search


[Back To The Top](#title)

---

<h2 id="how-to-contribute">💡 How To Contribute</h2>

- Make a fork of this repository
- Clone to you machine and entry on respective paste
- Create a branch with your resource: `git checkout -b my-feature`
- Commit your changes: `git commit -m 'feat: My new feature'`
- Push your branch: `git push origin my-feature`
- A green button will appear at the beginning of this repository
- Click to open and fill in the pull request information

<p align="center">
<i>Contributions, issues and features requests are welcome!</i><br />
<i>📮 Submit PRs to help solve issues or add features</i><br />
<i>🐛 Find and report issues</i><br />
<i>🌟 Star the project</i><br />
</p>

[Back To The Top](#title)

---

<h2 id="contributors">👤 Author And Contributors</h2>

<p>

<a href="https://github.com/hmasum52"><img width="60" src="https://avatars.githubusercontent.com/u/55390870?v=4"/>  
<a href="https://github.com/hmasum52">Hasan Masum</a>  

<a href="https://github.com/AshfaqRahman"><img width="60" src="https://avatars.githubusercontent.com/u/76648582?v=4"/>  
<a href="https://github.com/AshfaqRahman">Ashfaq Rahman</a>

</p>

[Back To The Top](#title)

---

<h2 id="supervisor">👨‍💻 Supervisor</h2>

- [Mohammad Tawhidul Hasan Bhuiyan](https://cse.buet.ac.bd/faculty/facdetail.php?id=tawhid), Lecturer, Department of Computer Science and Engineering Bangladesh University of Engineering and Technology Dhaka-1000, Bangladesh

[Back To The Top](#title)

---

<h2 id="license">🔏 License</h2>

Copyright © 2022 [Hasan Masum <hasanmasum1852@gmail.com>](https://github.com/hmasum52)

This project is licensed by [MIT License](https://api.github.com/licenses/mit).

[Back To The Top](#title)

---


<!-- // resolve xmlhttprequest
https://stackoverflow.com/questions/67253808/xmlhttprequest-error-while-using-http-post-flutter-web -->
<!-- 
https://github.com/zubairehman/flutter-boilerplate-project/blob/master/README.md -->