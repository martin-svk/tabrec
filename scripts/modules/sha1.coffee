class @Sha1

  # Get the SHA1 hash of message
  process: (msg) ->
    rotate_left = (n, s) ->
      t4 = (n << s) | (n >>> (32 - s))
      t4
    lsb_hex = (val) ->
      str = ""
      i = undefined
      vh = undefined
      vl = undefined
      i = 0
      while i <= 6
        vh = (val >>> (i * 4 + 4)) & 0x0f
        vl = (val >>> (i * 4)) & 0x0f
        str += vh.toString(16) + vl.toString(16)
        i += 2
      str
    cvt_hex = (val) ->
      str = ""
      i = undefined
      v = undefined
      i = 7
      while i >= 0
        v = (val >>> (i * 4)) & 0x0f
        str += v.toString(16)
        i--
      str
    Utf8Encode = (string) ->
      string = string.replace(/\r\n/g, "\n")
      utftext = ""
      n = 0

      while n < string.length
        c = string.charCodeAt(n)
        if c < 128
          utftext += String.fromCharCode(c)
        else if (c > 127) and (c < 2048)
          utftext += String.fromCharCode((c >> 6) | 192)
          utftext += String.fromCharCode((c & 63) | 128)
        else
          utftext += String.fromCharCode((c >> 12) | 224)
          utftext += String.fromCharCode(((c >> 6) & 63) | 128)
          utftext += String.fromCharCode((c & 63) | 128)
        n++
      utftext
    blockstart = undefined
    i = undefined
    j = undefined
    W = new Array(80)
    H0 = 0x67452301
    H1 = 0xefcdab89
    H2 = 0x98badcfe
    H3 = 0x10325476
    H4 = 0xc3d2e1f0
    A = undefined
    B = undefined
    C = undefined
    D = undefined
    E = undefined
    temp = undefined
    msg = Utf8Encode(msg)
    msg_len = msg.length
    word_array = new Array()
    i = 0
    while i < msg_len - 3
      j = msg.charCodeAt(i) << 24 | msg.charCodeAt(i + 1) << 16 | msg.charCodeAt(i + 2) << 8 | msg.charCodeAt(i + 3)
      word_array.push j
      i += 4
    switch msg_len % 4
      when 0
        i = 0x080000000
      when 1
        i = msg.charCodeAt(msg_len - 1) << 24 | 0x0800000
      when 2
        i = msg.charCodeAt(msg_len - 2) << 24 | msg.charCodeAt(msg_len - 1) << 16 | 0x08000
      when 3
        i = msg.charCodeAt(msg_len - 3) << 24 | msg.charCodeAt(msg_len - 2) << 16 | msg.charCodeAt(msg_len - 1) << 8 | 0x80
    word_array.push i
    word_array.push 0  until (word_array.length % 16) is 14
    word_array.push msg_len >>> 29
    word_array.push (msg_len << 3) & 0x0ffffffff
    blockstart = 0
    while blockstart < word_array.length
      i = 0
      while i < 16
        W[i] = word_array[blockstart + i]
        i++
      i = 16
      while i <= 79
        W[i] = rotate_left(W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16], 1)
        i++
      A = H0
      B = H1
      C = H2
      D = H3
      E = H4
      i = 0
      while i <= 19
        temp = (rotate_left(A, 5) + ((B & C) | (~B & D)) + E + W[i] + 0x5a827999) & 0x0ffffffff
        E = D
        D = C
        C = rotate_left(B, 30)
        B = A
        A = temp
        i++
      i = 20
      while i <= 39
        temp = (rotate_left(A, 5) + (B ^ C ^ D) + E + W[i] + 0x6ed9eba1) & 0x0ffffffff
        E = D
        D = C
        C = rotate_left(B, 30)
        B = A
        A = temp
        i++
      i = 40
      while i <= 59
        temp = (rotate_left(A, 5) + ((B & C) | (B & D) | (C & D)) + E + W[i] + 0x8f1bbcdc) & 0x0ffffffff
        E = D
        D = C
        C = rotate_left(B, 30)
        B = A
        A = temp
        i++
      i = 60
      while i <= 79
        temp = (rotate_left(A, 5) + (B ^ C ^ D) + E + W[i] + 0xca62c1d6) & 0x0ffffffff
        E = D
        D = C
        C = rotate_left(B, 30)
        B = A
        A = temp
        i++
      H0 = (H0 + A) & 0x0ffffffff
      H1 = (H1 + B) & 0x0ffffffff
      H2 = (H2 + C) & 0x0ffffffff
      H3 = (H3 + D) & 0x0ffffffff
      H4 = (H4 + E) & 0x0ffffffff
      blockstart += 16
    temp = cvt_hex(H0) + cvt_hex(H1) + cvt_hex(H2) + cvt_hex(H3) + cvt_hex(H4)
    temp.toLowerCase()
