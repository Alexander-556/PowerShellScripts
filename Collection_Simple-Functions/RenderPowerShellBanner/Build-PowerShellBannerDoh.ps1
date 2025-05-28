function Build-PowerShellBannerDoh {
    [CmdletBinding()]
    param (
        [int]$Delay = 0.55  # Milliseconds delay per character
    )

    $banner = @'
PPPPPPPPPPPPPPPPP                                                                                                SSSSSSSSSSSSSSS hhhhhhh                                lllllll lllllll 
P::::::::::::::::P                                                                                             SS:::::::::::::::Sh:::::h                                l:::::l l:::::l 
P::::::PPPPPP:::::P                                                                                           S:::::SSSSSS::::::Sh:::::h                                l:::::l l:::::l 
PP:::::P     P:::::P                                                                                          S:::::S     SSSSSSSh:::::h                                l:::::l l:::::l 
  P::::P     P:::::P  ooooooooooo wwwwwww           wwwww           wwwwwww eeeeeeeeeeee    rrrrr   rrrrrrrrr S:::::S             h::::h hhhhh           eeeeeeeeeeee    l::::l  l::::l 
  P::::P     P:::::Poo:::::::::::oow:::::w         w:::::w         w:::::wee::::::::::::ee  r::::rrr:::::::::rS:::::S             h::::hh:::::hhh      ee::::::::::::ee  l::::l  l::::l 
  P::::PPPPPP:::::Po:::::::::::::::ow:::::w       w:::::::w       w:::::we::::::eeeee:::::eer:::::::::::::::::rS::::SSSS          h::::::::::::::hh   e::::::eeeee:::::eel::::l  l::::l 
  P:::::::::::::PP o:::::ooooo:::::o w:::::w     w:::::::::w     w:::::we::::::e     e:::::err::::::rrrrr::::::rSS::::::SSSSS     h:::::::hhh::::::h e::::::e     e:::::el::::l  l::::l 
  P::::PPPPPPPPP   o::::o     o::::o  w:::::w   w:::::w:::::w   w:::::w e:::::::eeeee::::::e r:::::r     r:::::r  SSS::::::::SS   h::::::h   h::::::he:::::::eeeee::::::el::::l  l::::l 
  P::::P           o::::o     o::::o   w:::::w w:::::w w:::::w w:::::w  e:::::::::::::::::e  r:::::r     rrrrrrr     SSSSSS::::S  h:::::h     h:::::he:::::::::::::::::e l::::l  l::::l 
  P::::P           o::::o     o::::o    w:::::w:::::w   w:::::w:::::w   e::::::eeeeeeeeeee   r:::::r                      S:::::S h:::::h     h:::::he::::::eeeeeeeeeee  l::::l  l::::l 
  P::::P           o::::o     o::::o     w:::::::::w     w:::::::::w    e:::::::e            r:::::r                      S:::::S h:::::h     h:::::he:::::::e           l::::l  l::::l 
PP::::::PP         o:::::ooooo:::::o      w:::::::w       w:::::::w     e::::::::e           r:::::r          SSSSSSS     S:::::S h:::::h     h:::::he::::::::e         l::::::ll::::::l
P::::::::P         o:::::::::::::::o       w:::::w         w:::::w       e::::::::eeeeeeee   r:::::r          S::::::SSSSSS:::::S h:::::h     h:::::h e::::::::eeeeeeee l::::::ll::::::l
P::::::::P          oo:::::::::::oo         w:::w           w:::w         ee:::::::::::::e   r:::::r          S:::::::::::::::SS  h:::::h     h:::::h  ee:::::::::::::e l::::::ll::::::l
PPPPPPPPPP            ooooooooooo            www             www            eeeeeeeeeeeeee   rrrrrrr           SSSSSSSSSSSSSSS    hhhhhhh     hhhhhhh    eeeeeeeeeeeeee llllllllllllllll
'@ -split "`n"

    Write-Host
    Write-Host

    foreach ($line in $banner) {
        foreach ($char in $line.ToCharArray()) {
            Write-Host -NoNewline $char
            Start-Sleep -Milliseconds $Delay
        }
        Write-Host  # Move to next line
    }

    Write-Host
    Write-Host
}
