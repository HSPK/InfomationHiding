function [result,count,availabler,availablec] = binaryhide(cover,msg,goalfile,key,R0,R1,lumda)
%���ı��ļ�תΪ����������
frr=fopen(msg,'r');
[msg,count]=fread(frr,'ubit1');
fclose(frr);
%����ͼ�����
images=imread(cover);
image=round(double(images)/255);  %��������ȡ��
origin_image = image;
%ȷ��ͼ�����׵�ַ
[m,n]=size(image);
m=floor(m/10);  %�������ȡ��
n=floor(n/10);
temp=zeros([m,n]);
[row,col]=hashreplacement(temp,m*n,m,key,n);  %��m��nҲ��Ϊ��Կ������
%���������ת��Ϊ�������ص�ַ
for i=1:m*n
    if row(i)~=1
        row(i)=(row(i)-1)*10+1;
    end
    if col(i)~=1
        col(i)=(col(i)-1)*10+1;
    end
end
%�������8*8����
temp=zeros(8);
[randr,randc]=hashreplacement(temp,64,key,m,n);  %��m��nҲ��Ϊ��Կ������
%�������õ�ͼ���
[availabler,availablec,image]=available(msg,count,row,col,m,n,image,R1,R0,lumda,randr,randc);
%��ϢǶ��
for i=1:count
    p1bi=computep1bi(availabler(i),availablec(i),image);
    if msg(i,1)==1
        if p1bi<R1
            image=editp1bi(availabler(i),availablec(i),image,0,R1-p1bi+1,randr,randc);%ʹp1(Bi)>R1
        elseif p1bi>R1+lumda
            image=editp1bi(availabler(i),availablec(i),image,1,p1bi-R1-lumda+1,randr,randc);%ʹp1(Bi)<R1+lumda
        else
        end
    end
    if msg(i,1)==0
        if p1bi>R0
            image=editp1bi(availabler(i),availablec(i),image,1,p1bi-R0+1,randr,randc);%ʹp1(Bi)<R0
        elseif p1bi<R0-lumda
            image=editp1bi(availabler(i),availablec(i),image,0,R0-lumda-p1bi+1,randr,randc);%ʹp1(Bi)>R0-lumda
        else
        end
    end
end
%��Ϣд�ر���
image=round(image);%��ֹ�߽���ɢ���ȡ����ԭ
result=image;
imwrite(result,goalfile);
subplot(2,1,1),imshow(origin_image),title('ԭʼͼ��');
subplot(2,1,2),imshow(result),title(['ȡ��ֵR0��R1Ϊ',int2str(R0),'��',int2str(R1),'�Խ�׳����lumdaΪ',int2str(lumda),'�µ���Ϣ',int2str(count),'bits����Ч��']);