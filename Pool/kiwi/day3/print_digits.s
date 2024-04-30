.global _start
.intel_syntax noprefix

.data   #Section data avec les variables
    newline: .long 10   #ascii \n
    number: .long 48   #ascii '0'
    count: .long 10     #variable du compteur

.text
    _start:
        mov rbx, [count]    #on met la variable count dansle registre à décrémenter rbx
        jmp loop            #on rentre dans la loop
        
        write:              #fonction (?) pour write, le registre rsi est rempli avant l'appel (char *)
            mov rax, 1      #on met le syscall à write
            mov rdi, 1      #on met le filedescriptor à 1
            mov rdx, 1      #len à write (ici 1, on print char par char)
            syscall         #on appelle le syscall 1 (write)

            ret             #return

        loop:   #loop principale
            lea rsi, [number]   #met le char dans le buffer de write
            call write          #appelle write

            mov eax, [number]   #met l'ascii de number dans un registre (ici eax)
            add eax, 1          #décremente de 1 eax
            mov [number], eax   #remet à number la valeur modifiée

            sub rbx, 1      #décremente le compteur de 1
            cmp rbx, 0      #si le compteur = 0, true, sinon false
            je end          #on jump à end si l'instructions d'avant est true
            jmp loop        #sinon on relance la loop

        end:    #rentre dans end quand le code est terminé
            lea rsi, [newline]  #met le \n dans le buffer de write
            call write

            mov rax, 60         #change le syscall de 1 à 60 (write -> exit)
            mov rdi, 0          #code de sortie
            syscall
