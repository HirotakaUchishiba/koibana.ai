from fastapi import FastAPI, HTTPException
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import sessionmaker, relationship, session, joinedload
from sqlalchemy.orm import declarative_base
from passlib.context import CryptContext
from typing import Optional, List
from pydantic import BaseModel
import openai


# openai.api_key = "sk-xxxx"

app = FastAPI()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

DATABASE_URL = "postgresql://postgres:pgsqlpw@localhost:5432/user_data"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

class Question(BaseModel):
    question: str

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True, nullable=True)
    full_name = Column(String, nullable=True)
    hashed_password = Column(String)
    hobbies = relationship("Hobby", back_populates="user")

class Hobby(Base):
    __tablename__ = "hobbies"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    description = Column(String, nullable=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    user = relationship("User", back_populates="hobbies")

class UserCreate(BaseModel):
    username: str
    email: Optional[str] = None
    full_name: Optional[str] = None
    password: str

class HobbyCreate(BaseModel):
    name: str
    description: Optional[str] = None

class ChatMessage(BaseModel):
    sender_id: int
    receiver_id: int
    message: str

Base.metadata.create_all(bind=engine)

@app.post("/usercreate/")
def create_user(user: UserCreate):
    db = SessionLocal()
    try:
        hashed_password = pwd_context.hash(user.password)
        db_user = User(username=user.username, email=user.email, full_name=user.full_name, hashed_password=hashed_password)
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user
    except:
        db.rollback()
        raise HTTPException(status_code=400, detail="Username already registered")
    finally:
        db.close()

@app.get("/users/{user_id}")
async def get_user(user_id: int):
    db = SessionLocal()
    try:
        db_user = db.query(User).options(joinedload(User.hobbies)).filter(User.id == user_id).first()
        if db_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return db_user
    except:
        raise HTTPException(status_code=400, detail="Error Getting User")
    finally:
        db.close()

@app.post("/users/{user_id}/hobbies/")
def create_hobby_for_user(user_id: int, hobby: HobbyCreate):
    db = SessionLocal()
    try:
        db_user = db.query(User).filter(User.id == user_id).first()
        if db_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        db_hobby = Hobby(name=hobby.name, description=hobby.description, user_id=user_id)
        db.add(db_hobby)
        db.commit()
        db.refresh(db_hobby)
        return db_hobby
    except:
        db.rollback()
        raise HTTPException(status_code=400, detail="Error creating hobby")
    finally:
        db.close()

@app.get("/users/{user_id}/hobbies/", response_model=List[HobbyCreate])
def read_hobbies_for_user(user_id: int):
    db = SessionLocal()
    try:
        db_user = db.query(User).filter(User.id == user_id).first()
        if db_user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return db_user.hobbies
    except:
        raise HTTPException(status_code=400, detail="Error reading hobbies")
    finally:
        db.close()

@app.get("/users_by_hobby/{hobby_name}")
def get_users_by_hobby(hobby_name: str):
    db = SessionLocal()
    users = get_users_with_same_hobby(db, hobby_name)
    return users

@app.post("/chat/{sender_id}/{receiver_id}")
def create_chat_message(sender_id: int, receiver_id: int, message: ChatMessage):
    tablename = f"chat_{min(sender_id, receiver_id)}_{max(sender_id, receiver_id)}"
    create_table_if_not_exists(tablename)

    class ChatRecord(Base):
        __tablename__ = tablename

        id = Column(Integer, primary_key=True)
        sender_id = Column(Integer, ForeignKey('users.id'))
        receiver_id = Column(Integer, ForeignKey('users.id'))
        message = Column(String)

        sender = relationship("User", foreign_keys=[sender_id])
        receiver = relationship("User", foreign_keys=[receiver_id])

    db = SessionLocal()

    chat_record = ChatRecord(sender_id=sender_id, receiver_id=receiver_id, message=message.message)

    db.add(chat_record)
    db.commit()
    db.refresh(chat_record)

    return {"chat_record_id": chat_record.id}

@app.post("/get-answer")
async def get_answer(question: Question):
    response = openai.Completion.create(
        model="text-davinci-003",
        prompt=f"私は恋愛助手です。これから、女の子に返信することを助けます。彼女は何を送りますか？\n\nQ:{question.question}\nA:",
        temperature=0,
        max_tokens=100,
        top_p=1,
        frequency_penalty=0.0,
        presence_penalty=0.0,
        stop=["\n"]
    )

    response_text = response.choices[0].text

    return response_text

def get_users_with_same_hobby(db: session, hobby_name: str):
    hobbies = db.query(Hobby).filter_by(name=hobby_name).all()
    user_ids = [hobby.user_id for hobby in hobbies]
    users = db.query(User).filter(User.id.in_(user_ids)).all()

    return users

def create_table_if_not_exists(tablename):
    if not engine.dialect.has_table(engine, tablename):
        Base.metadata.tables[tablename].create(engine)

