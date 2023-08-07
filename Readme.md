1) Ставим Yandex Clod.
2) Ставим Terraform.
3) Создаем рабочий каталог /SF/terraform/B5.
4) Внутри рабочего каталога делаем yc init
5) Отвечаем на вопросы согласно примера:
% yc init
Welcome! This command will take you through the configuration process.
Pick desired action:
 [1] Re-initialize this profile 'default' with new settings
 [2] Create a new profile
Please enter your numeric choice: 2
Enter profile name. Names start with a lower case letter and contain only lower case letters a-z, digits 0-9, and hyphens '-': tf
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb in order to obtain OAuth token.

Please enter OAuth token: y0_AgAAAAAFLrLFAATuwQAAFLrLFAATuwAAADpPXSfI5mCXjGlQK2DCZ36_htHYj8MPTc
You have one cloud available: 'cloud-istokin' (id = b1gqtseqdlac2532u4n4). It is going to be used by default.
Please choose folder to use:
 [1] default (id = b1gb3d99eg100v17094f)
 [2] Create a new folder
Please enter your numeric choice: 1
Your current folder has been set to 'default' (id = b1gb3d99eg100v17094f).
Do you want to configure a default Compute zone? [Y/n] n

6) Создаем сервисный аккаунт:
% yc iam service-account create --name tf
id: aje094l2s5r1o87nhupm
folder_id: b1gb3d99eg100v17094f
created_at: "2023-08-03T08:15:03.888172698Z"
name: tf

7) Смотрим какие роли существуют:
% yc iam roles list

8) Добавляем роли сервисному аккаунту:
% yc iam service-account add-access-binding --id aje094l2s5r1o87nhupm --service-account-name tf --role vpc.admin
done (2s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: vpc.admin
      subject:
        id: aje094l2s5r1o87nhupm
        type: serviceAccount
% yc iam service-account add-access-binding --id aje094l2s5r1o87nhupm --service-account-name tf --role load-balancer.admin
done (2s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: load-balancer.admin
      subject:
        id: aje094l2s5r1o87nhupm
        type: serviceAccount
% yc iam service-account add-access-binding --id aje094l2s5r1o87nhupm --service-account-name tf --role compute.admin
done (2s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: compute.admin
      subject:
        id: aje094l2s5r1o87nhupm
        type: serviceAccount

9) Добавляем в переменные окружения данные:
% export YC_TOKEN=$(yc iam create-token)
% export YC_CLOUD_ID=$(yc config get cloud-id)
% export YC_FOLDER_ID=$(yc config get folder-id)

10) Получаем сипсок всех образов ОС в каталоге стандартных образов:
% yc compute image list --folder-id standard-images

11) Выводим информацию о последнем образе ubuntu:
% yc compute image get-latest-from-family --folder-id standard-images ubuntu-2204-lts

12) Копируем ID образа в конфигурацию виртуальной машины.
id: fd8bkgba66kkf9eenpkb

13) Описываем сущности:
Создаем виртуальную машину vm-01
Создаем виртуальную машину vm-02
Создаем сеть dmz
Создаем подсеть subnet-dmzСоздаем балансировщик sfnlb
Создаем целевую группу sfnlb-group1
Создаем целевую группу sfnlb-group1