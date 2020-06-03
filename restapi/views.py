# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.http import HttpResponse

# Create your views here.


def index():
    return HttpResponse("Hello, world. You're at Rest.")